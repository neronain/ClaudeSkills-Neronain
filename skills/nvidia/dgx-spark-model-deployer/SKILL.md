---
name: dgx-spark-model-deployer
description: Deploy, size, move and repair LLMs on NVIDIA DGX Spark (GB10) fleets with LMDS — fit, push/clone, stacked pairs, start failures, fleet updates.
when_to_use: Use whenever the user wants a Hugging Face or NGC model running on a DGX Spark or on the LMDS hub/nodes; asks whether a model fits, which slots/context/gpu-util to set, or which model to put on a node; wants to push, clone, restart, swap or remove a model; pastes an LMDS, vLLM or llama.cpp start/download/test error; or asks to update the hub and nodes so they match. Use it even when LMDS is not named but the target is GB10 / DGX Spark.
argument-hint: "<model URL/ID or bundle slug> [node]"
---

# DGX Spark Model Deployer

LMDS (Local Model Deploy Studio, repo `neronain/AutoDeployDGXProject`) is the tool for this job. Its generated controllers already carry every failure this team has hit on GB10 — port-ownership guards, runtime-architecture checks, KV pinning, crash explanations, live logs and feature tests. Drive LMDS and read its evidence. Do not hand-write launch scripts or `docker run` lines: a hand-made controller silently drops those fixes, and the lesson gets relearned on a customer machine.

If a machine has no LMDS, install it (`git clone https://github.com/neronain/AutoDeployDGXProject && cd AutoDeployDGXProject && ./install.sh`) rather than improvising.

Match the user's language (this team writes Thai).

## Know the environment first

Read `config/team-profile.yaml`. The facts that matter most:

- The **hub** is a control plane without a GPU (an OrbStack VM). It holds bundles, the node registry and the web console on port 8600. Run `lmds` there **from `~`**: `lmds deploy` writes to `./bundles` of the current directory, and a second copy of a slug in another bundle root makes later commands pick the wrong one.
- **Nodes** are reached through the hub: `lmds node run <node> <lmds command>` runs LMDS on the node, `lmds node ctl <node> <slug> <verb>` runs a controller verb. `lmds node list` is the source of truth for node names, IPs and sites.
- **Running on a node itself** (for example an OpenClaw agent on the Spark), the hub is usually out of reach. Run the same LMDS commands locally without the `node run <node>` prefix (`lmds ps`, `lmds fit <slug> --slots 3`, `lmds logs <slug> -f`) and controller verbs through the bundle's script: `~/bundles/<slug>/<slug>-single.sh test-tools` (`-stacked.sh` on a stacked head). New models, clones and fleet updates belong to the hub — hand the owner the hub command instead of improvising locally.
- The hub's git checkout (`main`) is the source of truth for code. Hub and nodes must run the same commit.

## Deploy a model to a node

1. **Gather evidence** instead of guessing sizes, parsers or images:
   ```bash
   lmds inspect <repo>
   lmds recipes <repo>
   lmds plan <repo> --target dgx-spark-single --no-llm --json
   ```
   `inspect` gives size, architecture, native context and special files; a recipe is an image + flags + parsers that already ran on GB10. Weights up to ~95 GB fit one Spark; larger needs a stacked pair (`--target dgx-spark-stacked`, see `references/runtime-notes.md`). Embedding and reranker repos are detected automatically (`--task embed` or `--task rerank` overrides).
2. **Generate on the hub**: `lmds deploy <repo> --target dgx-spark-single --no-llm --yes`. Add `--gguf Q8_0` to pick a GGUF variant and `--name <slug>` when the repo name is long — slugs over 64 characters cannot be pushed.
3. **Ship it**: `lmds node push <node> <slug> --download` downloads the weights on the node and verifies them. When another node already has the weights, `lmds node clone <slug> --from <a> --to <b>` copies node-to-node over the fastest shared link and verifies — minutes instead of a Hugging Face download.
4. **Size it before starting**: `lmds node run <node> fit <slug> --slots <n>` shows the RAM picture with every other model on that node counted; apply with `lmds node run <node> set <slug> --fit --slots <n>`. Rules in `references/sizing.md`.
5. **Start and prove it**: `lmds node run <node> start <slug>`, then `lmds node ctl <node> <slug> test-text` plus the verbs that fit the model — `test-tools`, `test-reasoning`, `test-vision`, `test-embed`, `test-rerank`. A server that answers `/health` is not done until its feature tests pass.
6. **Keep it**: `lmds node run <node> enable <slug>` turns on autostart. When replacing a model, leave the old bundle and weights in place (or `lmds node run <node> remove <slug> --keep-weights --yes`) so rollback is just a start.
7. **Report**: endpoint `http://<node-ip>:<port>/v1`, served model id, context per request, slots, RAM used/total, tests passed, what was stopped, and anything clients must change (model id, `max_tokens`).

## Sizing in one paragraph

A DGX Spark has one 121 GB pool shared with the OS; keep about 12 GB free. vLLM's `gpu-memory-utilization` is a fraction of the **whole** pool and is checked against free memory at start, so a leftover `0.85` makes restarts fail as soon as a neighbour model runs. Pin the KV cache (`--kv-cache-memory`) and set gpu-util to what the model needs — `set --fit` does both. Context can never exceed the model's native `max_position_embeddings`: beyond it quality collapses without any error, and LMDS refuses. In llama.cpp `--ctx-size` is a pool shared by all slots, so context per request is ctx ÷ slots. Formulas and measured numbers: `references/sizing.md`.

## Changing something that already runs

Many nodes serve customers. Before a restart check recent use (`lmds node ctl <node> <slug> logs 200`) or ask the owner, and prefer quiet hours. `lmds set` only saves settings; the running server keeps its old values until restart (the console shows "restart to apply"). Re-run the tests afterwards and never delete weights you might roll back to.

## When something fails

1. `lmds node run <node> doctor <slug>` names the cause and the fix.
2. Read the controller's own diagnosis: failed starts end with a "สาเหตุจาก log" line, and `lmds node ctl <node> <slug> logs -f` streams live.
3. Find the symptom in `references/troubleshooting.md` before changing anything, and change one variable at a time.

## Updating the hub and nodes

"Matches the hub" means three things on every node: the same LMDS commit, controllers rendered from the current templates, and a runtime (llama.cpp build or image) that knows every deployed model's architecture. An unknown axis is not a pass. The update sequence and checks are in `references/fleet-ops.md`; code changes always end with commit + push, hub install, node rollout and `lmds fleet check`.

## Guardrails

- Never type sudo passwords, HF tokens or API keys for the user — print the command and let the owner run it.
- Customer machines are read-only until the owner says go, and every change keeps a rollback path.
- Say "hardware-validated" only after the tests ran on that node; otherwise say "static-validated".
- Uncensored and red-team models are for authorized security work only.
- Debug vLLM inside its container; do not install host PyTorch or random packages.

## Skill files

| File | Read when |
|---|---|
| `config/team-profile.yaml` | Always, first |
| `references/sizing.md` | Choosing slots/context/KV, or putting two models on one Spark |
| `references/runtime-notes.md` | Picking engine, image or parsers; stacked pairs; MTP; multimodal |
| `references/fleet-ops.md` | Hub and node access, clone, safe swaps, updates and rollouts |
| `references/troubleshooting.md` | Any error message or odd behaviour |
| `references/research-workflow.md` | A model with no recipe or an unfamiliar architecture |
| `references/special-files-checklist.md` | Remote code, projectors, templates or parser plugins in the repo |
| `references/security.md` | Exposing endpoints or wiring agents and tools |
| `scripts/check_lmds_commands.py` | After an LMDS upgrade — confirms every `lmds` command in this skill still exists |
| `scripts/validate_skill.py` | After editing this skill |
