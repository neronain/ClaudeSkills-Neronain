# Sizing on DGX Spark (GB10, 121 GB unified memory)

## The rule

```text
usable RAM        ≈ 121 − 12 (OS and desktop headroom) ≈ 109 GB
vLLM model RAM    = weights + ~3 GB overhead + KV pin
KV pin            = slots × KV of one full-context request × 1.2   → --kv-cache-memory <bytes>
vLLM gpu-util     = model RAM ÷ total RAM + 0.02                  (vLLM checks free ≥ gpu-util × total at start)
llama.cpp RAM     = weights + ~1.5 GB + KV of the whole ctx pool   (count host RSS too: weights are mmapped)
a second model fits when the sum of every model's RAM ≤ usable RAM
```

`lmds fit <slug> --slots N [--context C]` computes this with real numbers — it reads `Model loading took` and `GPU KV cache size` from the running server's log and subtracts the other models on the node. `lmds set <slug> --fit …` writes the pin, slots, context and gpu-util together. When it refuses, it still saves settings unrelated to memory (port, served name) and names the maximum slots or the model to stop.

## Context

- Never above the native `max_position_embeddings` (see `lmds inspect` or `config.json`). Stretched RoPE starts fine but answers degrade silently; LMDS refuses such values.
- With a KV pin, context costs no extra RAM — concurrency does. Keep native context and choose slots for the real number of simultaneous users.
- llama.cpp splits `--ctx-size` evenly across `--parallel` slots. 128K per request with 2 slots needs ctx 262144 (twice the KV) or 1 slot. The console shows `N/request` when they differ.
- Hybrid and MLA architectures (Mamba, DeltaNet, sparse MLA) have tiny KV per token; dense GQA models (Llama-3.x 70B) have large KV. Very long context is only practical for the former.

## Measured on this fleet (one Spark unless noted)

| Model | Engine | Weights | KV per full request | Setting that worked | RAM | Decode, 1 stream |
|---|---|---|---|---|---|---|
| Nemotron-3-Super-120B-A12B NVFP4 | vLLM | 69.6 GiB | ~1.3 GB @ 262K | slots 3 · pin 8 GB · gpu-util 0.73 | ~88 GB | ~16 tok/s |
| Qwen3.5-122B-A10B NVFP4 | vLLM | 71.3 GiB | ~6 GB @ 262K | slots 3 · pin 12 GiB | ~95 GB | — |
| Qwen3.6-35B-A3B NVFP4 (MTP) | vLLM | ~25 GB | small | slots 4 · pin 15 GiB | ~44 GB | ~108 tok/s |
| Gemma-4 26B-A4B QAT GGUF (MTP) | llama.cpp | ~17 GB | small | ctx 65K × 2 slots | ~20 GB | ~100 tok/s |
| gpt-oss-120b MXFP4 GGUF | llama.cpp | 60 GB | ~9 GB @ 131K | ctx 131K · 1 slot | ~65 GB | ~58 tok/s |
| Nemotron-3-Nano-Omni-30B-A3B Q8 GGUF | llama.cpp | 35 GB | small | pool 1M · 4 slots (256K each) | ~46 GB | ~50 tok/s |
| Llama-3.3-70B NVFP4 (dense) | vLLM | 40 GB | ~20 GB @ 131K | slots 2 · gpu-util 0.7 | ~90 GB | ~5 tok/s |
| GLM-5.3-Flash NVFP4 (stacked TP=2) | vLLM, recipe image | 89 GiB per node | ~1.7 GB @ 262K | pin 3.5 GiB · ctx ≤ 262K | ~113 GB per node | ~10 tok/s |
| Qwen3-Embedding-8B | vLLM pooling | 14 GiB | — | ctx 32K · 2 slots | ~20 GB | — |
| Qwen3-Reranker-4B | vLLM pooling | 7.6 GiB | — | ctx 8K · 4 slots | ~16 GB | — |

Decode speed on one Spark is bound by memory bandwidth (273 GB/s), so **active** parameters decide it: ~12B active ≈ 16 tok/s, 3–4B active ≈ 100 tok/s, dense 70B ≈ 5 tok/s. Stacking two Sparks adds memory, not speed.

## Worked example — two models on one Spark

Nemotron-3-Super (88 GB) + Gemma-4 26B (20 GB) = 108 GB of 121 → fits. With the `--fit` gpu-util (0.73) Nemotron restarts while Gemma keeps running. With the old 0.85 the restart fails: `Free memory on device (97 GiB) … less than desired GPU memory utilization (0.85, 103 GiB)`.
