# Runtime Decision Matrix

| Artifact / need | Preferred runtime | Notes |
|---|---|---|
| ModelOpt NVFP4 / FP8 Transformers checkpoint | vLLM or exact author recipe | Verify `modelopt`, parser, ARM64/Blackwell support |
| GGUF | llama.cpp | Verify embedded template, projector, CUDA arch |
| Exact SGLang-only recipe | SGLang | Pin branch/PR and kernels |
| Dense model fitting one Spark | Single node first | Multi-node may add latency |
| Large MoE exceeding one Spark | Stacked/multi-node | Verify per-node memory and transport |
| Agent tools | Runtime with exact parser/template | Add required, auto, and continuation tests |
| Multimodal | Runtime with exact processor/projector | Add media sandbox and limits |
| 1M context | Exact tested recipe only | Memory fit does not imply acceptable TTFT |

## DGX Spark-specific checks

- ARM64 image manifest or local source build.
- Blackwell GB10 / SM121 compatibility.
- CUDA architecture for llama.cpp builds, currently often `121a-real`; re-verify.
- Unified-memory headroom.
- ConnectX/RoCE configuration for multiple nodes.
- NCCL and backend pins.
- Runtime image identity on all nodes.

## Distributed backend

Do not assume Ray. Select among:

- vLLM multiprocessing / MP;
- Ray;
- torchrun/NCCL;
- SGLang multi-node;
- llama.cpp RPC.

Use the backend demonstrated by the exact compatible recipe unless there is a documented reason to change it.
