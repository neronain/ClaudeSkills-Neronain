# Quality Gates

## Static

```bash
bash -n controller.sh
python3 scripts/validate_bundle.py bundle/
```

Also:

- compile Python helpers;
- verify ZIP contents;
- generate package checksums;
- ensure README commands match controller commands;
- search for unresolved placeholders;
- check that paths are configurable;
- check that no secret is embedded.

## Runtime

When hardware is available:

1. host `nvidia-smi`;
2. fresh-container `nvidia-smi`;
3. runtime/parser inventory;
4. download and verify;
5. start and health;
6. `/v1/models`;
7. text;
8. language-specific test when relevant;
9. reasoning;
10. tools required;
11. tools auto;
12. tool-result continuation;
13. multimodal;
14. benchmark;
15. stress;
16. stop and restart.

## Acceptance

A deployment is not accepted merely because the server starts. Required agent features must return the correct structured protocol.
