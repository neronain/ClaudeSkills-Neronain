# Special-Files Checklist

## Transformers checkpoints

Inspect and explain:

- `config.json`
- `generation_config.json`
- `tokenizer_config.json`
- `tokenizer.json`
- `special_tokens_map.json`
- `chat_template.jinja`
- `processor_config.json`
- `preprocessor_config.json`
- `hf_quant_config.json`
- `quantization_config.json`
- `model.safetensors.index.json`
- custom `configuration_*.py`
- custom `modeling_*.py`
- parser plugins
- MTP or speculative-decoding heads

## GGUF

Inspect:

- exact quant file;
- SHA-256 and size;
- embedded tokenizer/template;
- native quant versus converted precision;
- `mmproj` requirements;
- split GGUF parts;
- runtime commit requirements;
- model-specific flags.

## Optional or dangerous artifacts

Do not blindly download:

```text
*.bak
calibration tensors
input-scale experiments
old model copies
training checkpoints
optimizer state
unreferenced projectors
```

If remote code or repository helper scripts are required, pin and review them. Mention the trust boundary in the README.
