# Example requests

These double as a manual test set: each should be handled with LMDS commands, never hand-written scripts.

1. "เอา Qwen/Qwen3-Reranker-4B ลง dgx-spark04 คู่กับ embedding ที่มีอยู่ ให้ RAM พอดี" — inspect and recipes, deploy (rerank task), push with download, fit counting the other models, start, `test-rerank`, enable.
2. "Nemotron-3-Super บน spark03 ขยับ context เป็น 500K ได้ไหม" — native context is 262,144, so refuse with the reason and offer RAG or a native long-context model.
3. "start qwen3-8-flash-next บน spark-worker แล้วขึ้น หยุดก่อน health ผ่าน" — doctor and logs show `unknown model architecture`; repair the runtime and re-test.
4. "gemma ตั้ง context 128K แต่ Score บอก 65536" — llama.cpp splits context across slots; ctx 262144 with 2 slots, or 1 slot.
5. "อัปเดต hub กับทุก node ให้ตรงกันแล้วเช็คให้ด้วย" — commit and push, hub install, bundles refresh, node install for all, fleet check; report each axis.
6. "clone gemma จาก spark-head ไป spark-worker" — clone dry-run, clone, verify, no autostart unless asked.
