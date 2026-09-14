# Security

- **Credentials**: never enter sudo passwords, Hugging Face tokens or API keys on the user's behalf — print the command for the owner. Keep tokens out of bundles and scripts.
- **Endpoints**: controllers bind `0.0.0.0` without an API key unless told otherwise, which is acceptable only on a private LAN. On shared networks start with `API_KEY=…` or bind `127.0.0.1` behind a gateway.
- **Remote code**: `trust_remote_code` and repository helper scripts need review; LMDS asks for approval.
- **Agents and tools**: the model never executes tools, the client does. Sandbox execution, allowlist commands and paths, cap time and output, confirm destructive actions, log every call.
- **Uncensored and red-team models**: authorized security work only; never give their tools production credentials or an unrestricted shell.
- **Customer machines**: read-only by default; changes need the owner's go-ahead and a rollback path.
