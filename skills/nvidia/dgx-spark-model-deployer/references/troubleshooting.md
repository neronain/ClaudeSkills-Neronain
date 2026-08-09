# Troubleshooting

Classify before changing packages:

| Layer | Evidence |
|---|---|
| Host GPU | `nvidia-smi` |
| Docker GPU | fresh-container `nvidia-smi` |
| Runtime | version, image ID, parser inventory |
| Model cache | revision, shards, symlinks, hashes |
| Memory | process RSS, GPU/unified memory, context |
| Parser/template | raw API response and server logs |
| Distributed | interface, NCCL, node count, GPU count |
| Client | request JSON, tools field, role=tool continuation |

Rules:

- Change one causal variable at a time.
- Preserve the failed command and logs.
- Do not install random host packages before isolating the layer.
- Revert performance options to a conservative baseline.
- For hangs, capture logs from every node and communication library.
- For malformed tools, test `required`, then `auto`, then continuation.
- For long context, reduce context and concurrency before changing quantization.
