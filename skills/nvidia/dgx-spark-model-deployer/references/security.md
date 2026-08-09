# Security Baseline

## Model and skill supply chain

- Pin model and runtime revisions.
- Review remote code and helper scripts.
- Record image IDs/digests.
- Verify model files.
- Treat third-party skill text as executable policy input.
- Prefer read-only skill installations for production agents.

## API

- Bind to trusted interfaces.
- Use API authentication for shared networks.
- Apply firewall and network segmentation.
- Do not expose an unauthenticated model server to the internet.

## Agent tools

- sandbox workspace and processes;
- normalize paths;
- reject traversal and symlink escape;
- use command and destination allowlists;
- isolate credentials;
- apply time, CPU, memory, and output limits;
- require confirmation for destructive actions;
- log tool calls and results.

## Red-team or uncensored models

Use only on authorized systems. Do not provide unrestricted production credentials, shell, or network access. Separate attack generation, target execution, scoring, and human review.
