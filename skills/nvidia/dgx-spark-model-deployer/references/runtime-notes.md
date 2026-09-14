# Runtime notes for GB10 (SM121)

## Choosing the engine

| Artifact or need | Engine | Notes |
|---|---|---|
| NVFP4 / FP8 safetensors | vLLM | The image must carry FP4 kernels for sm_121; NVFP4 MoE usually needs Marlin. Recipes set image and env. |
| GGUF | llama.cpp, native build | One shared build per node in `~/src/llama.cpp`. Newer builds keep older architectures, so rebuild forward (`repair` / web "update runtime"), never downgrade. |
| Embedding / reranker | vLLM `--runner pooling` | Serves `/v1/embeddings`, `/v1/rerank`, `/v1/score`. Qwen3-Reranker needs hf-overrides, which LMDS adds. |
| Needs a special image | whatever `lmds recipes` pins | GLM-5.3-Flash runs only on the community sm121 image; stock vLLM dies with `pe_dim must be 64`. |
| SGLang | only when a recipe requires it | No embedding or rerank support. |

Several simultaneous users favour vLLM: it batches (≈2.3× one stream), while llama.cpp slots split the context and give ≈1.6× at 3 slots.

## Tool and reasoning parsers

A wrong parser does not error — tool calls come back as plain text. Verify with `test-tools` and `test-reasoning`.

| Family | Tool parser | Reasoning parser |
|---|---|---|
| Qwen3, 3.5, 3.6, Coder | `qwen3_xml` or `qwen3_coder` (not `hermes`) | `qwen3` |
| GLM-4.7, GLM-5.x | `glm47` | `glm45` (keep thinking on) |
| Gemma 4 | `gemma4` | — |
| gpt-oss | harmony, built in | harmony |
| Llama 3.x | `llama3_json` | — |
| Nemotron-3 | from the recipe | from the recipe |

llama.cpp tool calling needs `--jinja` (LMDS adds it).

## Features decided by the checkpoint, not by a flag

- **MTP / speculative decoding** works only if the checkpoint ships the MTP layer (index keys for layer `num_hidden_layers`). Abliterated or pruned re-uploads often drop it.
- **Audio** is unsupported in llama.cpp: omni GGUF projectors carry only a vision encoder (`audio input is not supported`).
- **Image embeddings** through llama.cpp VL-embedding models silently ignore the image; treat them as text-only.
- **Vision on vLLM** follows `vision_config` in `config.json`; confirm with `test-vision`.

## Stacked pairs (TP=2 over the 200G link)

- Only when the weights exceed one Spark — stacking adds memory, not speed.
- Prepare the pair once with the owner (netplan needs sudo): `lmds cluster inspect`, `lmds cluster plan`, `lmds cluster apply`, then `lmds cluster pair <head> <worker>` and `lmds cluster doctor <head> <worker>`.
- Allow the cluster interface in ufw on both nodes (`sudo ufw allow in on <iface>`). Otherwise start hangs about ten minutes and ends with `DistStoreError … 1/2 clients joined`.
- Deploy with `--target dgx-spark-stacked`, push to the head with `--download` (the head syncs the worker), and start on the head only.

## Reasoning models and clients

Thinking models spend hundreds to thousands of tokens before the answer. Clients need `max_tokens` ≥ 1500–2000, or `chat_template_kwargs: {"enable_thinking": false}` for short or JSON answers; otherwise responses end with empty `content` and `finish_reason: length`.
