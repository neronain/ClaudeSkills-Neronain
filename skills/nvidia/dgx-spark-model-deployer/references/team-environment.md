# Team Environment

Edit `config/team-profile.yaml` for each team or site. The bundled values reflect the original deployment environment and are defaults only.

Default profile:

```text
Master IP: 10.100.152.1
Worker IP: 10.100.152.2
SSH user: neronain
Hugging Face cache: /home/neronain/.cache/huggingface
API port: 8000
Docker GPU flag: --gpus all
```

Rules:

- Explicit user values override this profile.
- Logs and host commands override stale documentation.
- Do not assume the management interface is the high-speed data interface.
- Resolve the interface owning the selected IP before setting NCCL, Gloo, UCX, or Ray variables.
- Do not assume `/home/neronain` on another team's system.
- Keep API keys and Hugging Face tokens out of committed scripts where possible.
