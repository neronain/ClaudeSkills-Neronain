---
name: DGX Spark Model Deployer
version: 3.0.0
description: Build verified DGX Spark deployment bundles for Hugging Face and NGC models.
when_to_use: Use for model fit analysis, vLLM or llama.cpp controllers, single or stacked Sparks, runtime repair, tool calling, multimodal tests, README, and ZIP delivery.
argument-hint: "<model URL or ID> [single|stacked|both]"
user-invocable: true
---

# DGX Spark Model Deployer

Build an evidence-backed, model-specific deployment bundle for NVIDIA DGX Spark. Support vLLM, llama.cpp, SGLang, single-node, and multi-node deployments. Do not produce a generic launch command when the exact repository requires custom files, parsers, kernels, or runtime pins.

## When to use

Use this skill when the user:

- provides a Hugging Face, NVIDIA NGC, GitHub, or model repository URL;
- asks whether a model fits one or more DGX Spark systems;
- requests a Bash controller, Docker launch, model downloader, cache synchronizer, README, tests, client settings, or ZIP;
- needs tool calling, reasoning, multimodal, long-context, coding-agent, OpenClaw, Hermes, Claude Code, or VS Code compatibility;
- provides deployment logs and asks for a repair or revised controller.

Do not use this skill for ordinary CUDA application deployment unrelated to model inference.

## Required outcome

Unless the user asks only for analysis, create a durable bundle:

```text
<model-slug>/
├── <model-slug>-single.sh             # single-node controller, when applicable
├── <model-slug>-stacked.sh            # multi-node controller, when applicable
├── README.md
├── SPECIAL_FILES.md                   # required when repository-specific files matter
├── MODEL_PROFILE.yaml
├── PACKAGE_SHA256SUMS
└── optional tests, helpers, or client examples
```

Also create a ZIP. Link every generated artifact.

A controller should expose the relevant subset of:

```text
prepare-runtime
runtime-info
download
verify-files
sync-worker
verify-worker
start
stop
restart
status
logs
props
bench
test-text
test-reasoning
test-tools required
test-tools auto
test-tool-loop
test-image
test-audio
test-video
stress
client-config
```

## Operating principles

1. Research the exact repository before writing the controller.
2. Use current primary sources: exact model card, file tree, configs, upstream runtime docs, container registry, and relevant source commits.
3. Inspect small repository files, not only the README.
4. Separate verified facts, inference, and unverified community claims.
5. Choose runtime and topology from evidence, not model-family habit.
6. Pin model revisions and runtime versions or commits whenever practical.
7. Keep model files in persistent host storage.
8. Run GPU checks inside the selected container; do not install host PyTorch merely to test vLLM.
9. On DGX Spark Docker, prefer `--gpus all`; do not add `--runtime=nvidia` unless the host explicitly requires it.
10. Validate generated Bash with `bash -n`.
11. Distinguish static validation from hardware validation.
12. Treat generated tool calls as untrusted requests. The agent client executes tools, not the inference server.

## Start here

Read these files progressively:

1. [Team environment](references/team-environment.md)
2. [Research workflow](references/research-workflow.md)
3. [Runtime decision matrix](references/runtime-decision-matrix.md)
4. [Controller contract](references/controller-contract.md)
5. [Special-files checklist](references/special-files-checklist.md)
6. [Quality gates](references/quality-gates.md)
7. [Security baseline](references/security.md)
8. [Troubleshooting](references/troubleshooting.md)
9. [Delivery contract](references/delivery-contract.md)

Use [MODEL_PROFILE template](templates/MODEL_PROFILE.yaml) as the internal source of truth for each deployment.

## Phase 1 — Resolve the request

Extract without repeating questions already answered:

- exact model URL or ID;
- requested revision, if any;
- topology: single, stacked, both, or recommendation needed;
- desired runtime, if explicitly requested;
- required modalities and features;
- target clients and agent frameworks;
- context, concurrency, port, storage, and network constraints;
- existing controllers or services that may occupy GPU memory or the API port.

Read `config/team-profile.yaml`. Treat it as a default, not immutable truth. Logs and explicit user statements override it.

## Phase 2 — Research the exact model

Collect and record:

- architecture, total parameters, active parameters, dense versus MoE;
- quantization format and mixed-precision exclusions;
- total repository size, indexed tensor size, shard count, and optional artifacts;
- native and tested context lengths;
- official or community-tested hardware;
- required runtime, container, version, branch, PR, or source commit;
- tool parser and tool chat template;
- reasoning parser and request-level controls;
- `trust_remote_code` requirements;
- image/audio/video processors and projectors;
- MTP/speculative decoding requirements;
- attention, MoE, KV-cache, Mamba, or custom kernel requirements;
- license and commercial-use constraints;
- known hangs, output corruption, parser failures, or memory limits.

When current web access exists, verify all unstable facts online. Prefer official documentation and source repositories. Treat benchmarks from community posts as environment-specific.

## Phase 3 — Inventory repository files

Inspect:

```text
config.json
generation_config.json
tokenizer_config.json
tokenizer.json
chat_template.jinja
processor_config.json
preprocessor_config.json
hf_quant_config.json
quantization_config.json
model.safetensors.index.json
configuration_*.py
modeling_*.py
*.gguf
mmproj*.gguf
parser plugins
runtime helper scripts
calibration files
backup files
```

Parse safetensors indexes rather than hard-coding shard names. For GGUF, identify whether tokenizer, template, and multimodal metadata are embedded and whether an `mmproj` is required.

Generate `SPECIAL_FILES.md` whenever a file affects correctness, security, parsing, multimodal support, or reproducibility.

## Phase 4 — Recommend topology and runtime

Use this order:

1. Exact purpose-built runtime named by the model author.
2. Exact official runtime/container recipe.
3. Current compatible upstream runtime with verified architecture and parsers.
4. Pinned community runtime when official support is absent.
5. A locally built runtime only when required.

Common choices:

- vLLM for ModelOpt/NVFP4, Transformers checkpoints, OpenAI-compatible serving, and structured tool parsers.
- llama.cpp for GGUF, native quant formats, and compact single-node deployments.
- SGLang when the exact model card or tested recipe requires its kernels or scheduling.
- Multi-process, Ray, or another distributed backend only when supported by the exact runtime recipe. Do not force Ray when a tested MP/NCCL path is preferred.

For one DGX Spark, reserve unified memory for runtime, CUDA buffers, and KV cache. For two or more nodes, account for per-node weights, communication buffers, context, concurrency, and link topology.

## Phase 5 — Design the controller

Read `references/controller-contract.md` and select the nearest template:

- `templates/single-vllm-controller.sh`
- `templates/stacked-vllm-controller.sh`
- `templates/single-llamacpp-controller.sh`

Do not copy a prior model's flags without re-verification.

Required qualities:

- editable configuration block near the top;
- persistent cache or model directory;
- pinned model revision;
- runtime lock or digest recording;
- resumable download;
- model and special-file verification;
- clean lifecycle commands;
- health checks and useful logs;
- safe defaults for context and concurrency;
- client configuration;
- model-specific feature tests;
- no autostart unless explicitly requested.

For stacked deployments:

- run the controller from the designated master;
- verify passwordless SSH or the selected orchestration channel;
- copy only the intended model/runtime assets;
- compare manifests on every node before start;
- verify the expected node and GPU count before serving;
- expose only one API endpoint;
- preserve logs from every node.

## Phase 6 — Configure features

### Tool calling

Enable auto tool choice only with a verified parser and template. Add tests for:

1. `tool_choice=required`;
2. `tool_choice=auto`;
3. a two-turn tool loop with `role=tool`;
4. malformed or unexpected argument detection.

Keep `parallel_tool_calls=false` until the exact model/runtime passes tests. State any model-specific limitations such as one call at a time or arrays serialized as strings.

### Reasoning

Use the exact reasoning parser or embedded template behavior. Support low/medium/high or thinking on/off only when the model supports it. Ensure the output budget is large enough. Do not expose raw reasoning to end users by default.

### Multimodal

Only advertise modalities verified for the exact checkpoint. Use a dedicated read-only media directory, per-prompt limits, and the correct projector/processor files.

### Long context

Start with a practical baseline. Reserve input, output, template, tool-schema, image-token, and reasoning headroom. Increase context one step at a time and repeat stress tests.

### Performance

Treat these as model-specific:

```text
FP8 or quantized KV
prefix caching
chunked prefill
CUDA graphs / eager mode
attention backend
MoE backend
Mamba cache dtype
expert parallelism
MTP / speculative decoding
custom all-reduce
```

## Phase 7 — Validate

Run:

```bash
bash -n <controller>.sh
python3 scripts/validate_bundle.py <bundle-directory>
```

When hardware access exists, test:

```text
host GPU
fresh-container GPU
runtime version/parser inventory
download
file verification
start
health
models endpoint
text
reasoning
tools required
tools auto
tool-loop continuation
multimodal features
stress
stop
restart
```

Record failures and exact fixes in the README. Never state that the deployment was hardware-tested when only static checks ran.

## Phase 8 — Deliver

Provide:

- recommendation and key tradeoffs;
- exact selected model/revision/runtime/topology;
- artifact links;
- first-run commands;
- default context/concurrency;
- special-file notes;
- acceptance-test sequence;
- client settings;
- limitations and validation status.

Keep the final response practical. Do not bury the download links.

## Repair workflow

When logs are provided:

1. preserve the exact failing command and environment;
2. classify the failure: host GPU, Docker GPU, image, architecture, kernel, model files, parser/template, memory, distributed transport, or client protocol;
3. change one causal variable at a time;
4. update controller, README, and troubleshooting notes together;
5. re-run static validation;
6. deliver a new versioned ZIP.

## Security

For agent or team use:

- never provide unrestricted shell/filesystem/network access by default;
- validate paths and JSON arguments;
- prevent symlink escape;
- use command and network allowlists;
- isolate credentials;
- set execution time and output limits;
- confirm destructive actions;
- log prompts, responses, tool calls, and execution results;
- treat third-party skills, model remote code, and repository helper scripts as untrusted until reviewed.

## Supporting tools

Use these helpers when useful:

```bash
python3 scripts/scaffold_bundle.py --help
python3 scripts/inventory_snapshot.py --help
python3 scripts/hash_manifest.py --help
python3 scripts/validate_bundle.py --help
python3 scripts/validate_skill.py .
```

## Claude Code notes

Store personal installations at `~/.claude/skills/dgx-spark-model-deployer/` or project installations at `.claude/skills/dgx-spark-model-deployer/`.

Use WebSearch/WebFetch for current research and Bash/Read/Write/Edit for artifacts. Do not pre-approve destructive shell commands. Generate files in the user's repository or requested output directory, then run the validators.


## Controller portability standard

Every newly generated controller must follow these rules:

```text
No pure numeric Bash literal may contain underscore separators.
Context must be overridable by environment and `--context`.
API port must be overridable by environment and `--port`.
Bind address and advertised client address must be separate.
Single-node controllers must not hard-code a master or cluster IP.
Advertised IP selection must prefer explicit IP/interface and route source.
Stacked controllers must keep cluster transport IPs separate from the public API URL.
```

Forbidden Bash arithmetic:

```bash
(( model_size > 25_000_000_000 ))
```

Correct forms:

```bash
MODEL_SIZE_BYTES="25000000000"
[[ "$actual_size" == "$MODEL_SIZE_BYTES" ]]
```

For GGUF artifacts, prefer exact byte size, the `GGUF` magic header, and SHA-256 over a lower-bound-only check.

Every controller should support:

```text
--context
--port
--bind
--advertise-ip
--interface
--client-input
--client-output
network-info
```

Avoid selecting the first result from `hostname -I` except as a final fallback. Prefer the source address from `ip route get`, or a user-selected interface.

With `set -o pipefail`, avoid `producer | grep -q` feature checks because the producer can receive SIGPIPE after an early match. Capture output first or use direct inspect/test APIs.
