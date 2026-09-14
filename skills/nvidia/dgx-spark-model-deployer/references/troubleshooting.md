# Troubleshooting

Start with `lmds node run <node> doctor <slug>` and the controller's "สาเหตุจาก log" line (or `lmds node ctl <node> <slug> logs -f`). Classify the layer before changing anything, and change one variable at a time.

| Symptom | Cause | Fix |
|---|---|---|
| `unknown model architecture: 'X'`, console says the server stopped before health | The node's shared llama.cpp build predates the model | `lmds node run <node> repair <slug>` or the console's "update runtime" (10–15 min; newer builds keep old architectures) |
| `Free memory on device … less than desired GPU memory utilization` | gpu-util × total exceeds free memory because another model runs | `lmds node run <node> set <slug> --fit --slots <n>` |
| `port N ถูกใช้อยู่แล้ว`, or tests say the port answers with another model | Two bundles use the same port | `set <slug> --port <p>`, then start |
| Context set to 128K but requests are limited to 64K | llama.cpp splits `--ctx-size` across slots | ctx = per-request × slots, or 1 slot |
| Every test warns about RoPE, answers degrade | Context above native `max_position_embeddings` | Set context ≤ native |
| Empty `content`, `finish_reason: length` | A reasoning model spent `max_tokens` thinking | Client `max_tokens` ≥ 1500, or `enable_thinking: false` |
| Stacked start hangs ~10 min, then `DistStoreError … 1/2 clients joined` | Worker cannot reach the head's rendezvous (ufw) | Owner runs `sudo ufw allow in on <cluster iface>` on both nodes; `lmds cluster doctor <head> <worker>` |
| `pe_dim must be 64 for fp8_ds_mla` (GLM-5.x) | Stock vLLM lacks NoPE MLA on SM121 | Use the image from `lmds recipes <repo>` |
| `audio input is not supported` | The GGUF projector has no audio encoder | Vision-only on llama.cpp; audio needs a vLLM omni path |
| Push refused: slug invalid, longer than 64 | Long repo name | `lmds deploy <repo> --name <short-slug> --no-llm --yes` |
| `download … กำลังรันอยู่แล้ว (.download.lock)` | A live process holds the download lock (the message names its pid) | Wait for it, or kill that pid; `download` again resumes |
| Clone refused: not enough space | Target disk | Free space on the target, then clone again |
| `fit` refuses: ไม่พอ | Not enough RAM with the other models | Fewer slots or shorter context, or stop the model it names |
| `node install` refused: hub has uncommitted files | Dirty hub checkout | Commit and push first |
| `lmds config show` or install hangs | Desktop keyring (D-Bus) blocks | `LMDS_NO_KEYRING=1` (install.sh already sets it) |
| A change does not show up, or topology flips between single and stacked | The same slug exists in two bundle roots | Run from `~` and delete the stale copy (`lmds deploy` warns) |

If the cause is still unclear, capture the failing command and full logs from every node involved before trying fixes, and prefer reverting to the recipe's settings over tuning new flags.
