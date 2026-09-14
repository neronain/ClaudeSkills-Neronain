# Research workflow (models without a recipe)

Run `lmds recipes <repo>` and `lmds inspect <repo>` first. A recipe already encodes the image, flags and parsers that ran on GB10 — research only what it does not cover.

| Area | Evidence | Where |
|---|---|---|
| Architecture, active parameters | `config.json`, model card | Repo |
| Native context | `max_position_embeddings`, `rope_scaling` | `config.json` |
| Quantization | `hf_quant_config.json`, `quantization_config` | Repo |
| Size and shards | Index and file sizes | `lmds inspect` |
| Runtime support | Architecture in the vLLM registry or llama.cpp `llm-arch` | Runtime source, controller `check-runtime` |
| Parsers | Model card, chat-template markers | Repo, runtime docs |
| MTP, projector, remote code | Index keys, `mmproj*`, `modeling_*.py` | Repo |
| Known failures | Issues and community recipes (label them as community) | GitHub, HF discussions |

Label every claim: "verified on this fleet", "officially documented", "community-reported" or "inferred". Runtime tags, parser names and kernel support change weekly, so verify them at task time.

Once a model passes its tests on hardware, add it to `src/lmds/recipes/catalog.yaml` in the LMDS repo with `validated_on`, so the next deploy gets the working settings automatically.
