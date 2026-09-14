# Special files

`lmds inspect` flags repository files that change loading or behaviour and records them in the bundle's `SPECIAL_FILES.md`. Review these by hand when they appear:

| File | Why it matters |
|---|---|
| `chat_template.jinja`, `tokenizer_config.json` | Tool and reasoning markers — a wrong template breaks tool calls |
| `hf_quant_config.json`, `quantization_config.json` | Quant format, which decides image and kernels |
| `model.safetensors.index.json` | Shard list; whether MTP layers exist |
| `configuration_*.py`, `modeling_*.py` | Remote code — needs approval |
| `mmproj*.gguf`, `processor_config.json` | Projector — which modalities really exist |
| Split GGUF parts (`-00001-of-0000N`) | All parts must be present; part 1 is the model file |
| `*.bak`, calibration tensors, optimizer state | Do not download |

For GGUF the controller checks exact size, the `GGUF` magic and SHA-256, and whether the chat template is embedded.
