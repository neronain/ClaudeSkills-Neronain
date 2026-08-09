# Research Workflow

## Evidence table

Create an internal table with:

| Area | Exact evidence | Source | Confidence |
|---|---|---|---|
| Architecture | | | |
| Active parameters | | | |
| Weight size | | | |
| Context | | | |
| Runtime | | | |
| Tool parser | | | |
| Reasoning parser | | | |
| Special files | | | |
| Tested hardware | | | |
| Known failures | | | |
| License | | | |

## Search order

1. Exact model card.
2. Repository tree and pinned revision.
3. Small config/template/quantization files.
4. Upstream/base model.
5. Official runtime documentation.
6. Runtime source code and parser registry.
7. Official hardware recipe.
8. Community benchmarks and issue reports.

## Freshness

Runtime tags, parser names, PRs, commits, container manifests, licenses, and known bugs are unstable. Verify them at task time.

## Source quality

Prefer official model authors, NVIDIA, vLLM, llama.cpp, SGLang, Hugging Face repository files, and source commits. Community posts may demonstrate feasibility but do not establish universal performance or stability.

## Claims

Use language such as:

- "Officially documented"
- "Verified by the exact model card"
- "Reported by a community recipe"
- "Inferred from indexed tensor size"
- "Not yet verified on DGX Spark"
