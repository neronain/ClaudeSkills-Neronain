# Fleet operations

## Access

From the Mac, the hub is the OrbStack VM named in `config/team-profile.yaml`:

```bash
orb -m Autodeploy bash -lc 'cd ~ && export LMDS_NO_BANNER=1 && lmds node list'
```

Start every hub command with `cd ~`. `orb` inherits the Mac's working directory, and `lmds deploy` would then write the bundle into that Mac folder — a second copy of the slug that later commands may pick instead of `~/bundles`.

## Everyday commands

| Goal | Command |
|---|---|
| What runs on a node | `lmds node run <node> ps` |
| Preview sizing | `lmds node run <node> fit <slug> --slots <n>` |
| Apply sizing | `lmds node run <node> set <slug> --fit --slots <n>` |
| Restart | `lmds node run <node> restart <slug>` |
| Live logs | `lmds node ctl <node> <slug> logs -f` |
| Autostart | `lmds node run <node> enable <slug>` |
| Remove, keep weights | `lmds node run <node> remove <slug> --keep-weights --yes` |
| Push from the hub | `lmds node push <node> <slug> --download` |
| Copy node to node | `lmds node clone <slug> --from <a> --to <b> --dry-run` |

The web console on the hub (port 8600) exposes the same actions: Fit, Clone, logs Follow, update runtime and the Fleet consistency card.

## Clone

Clone installs a one-time SSH key on the target (revoked afterwards), checks the target's free disk, and rsyncs weights plus bundle directly between the two nodes — over the cluster link when both have one. It skips download scratch files and verifies SHA-256 on the target. `cluster.env` is not copied: a stacked bundle on a new head needs `lmds cluster write <slug> --on <head>`.

## Update the hub and every node

1. Commit and push the LMDS repo. The hub refuses to ship an uncommitted checkout to nodes.
2. On the hub: `cd ~/AutoDeployDGXProject && LMDS_SKIP_PREREQ=1 LMDS_ASSUME_YES=1 ./install.sh && systemctl --user restart lmds-web`.
3. `lmds bundles refresh --all --if-older` re-renders the hub's own bundles from their profiles (offline).
4. `lmds node install --all` updates code, refreshes controllers and checks runtimes on each node (`--no-runtimes` skips the 10–15 minute llama.cpp rebuilds).
5. `lmds fleet check` must show code ✓ controller ✓ runtime ✓ on every node. Unknown is not a pass; unreachable nodes are reported by name.

Finally confirm the hub checkout, `origin/main` on GitHub and the hub's running commit are identical.

## Swap models on a customer node

1. Check recent use in the logs and agree a time with the owner.
2. Download or clone the new model first while the old one keeps serving.
3. Stop the old model, `set --fit` the new one, start it and run its tests.
4. `enable` the new model, keep the old bundle and weights for rollback, and tell the owner the endpoint and model id clients must use. Endpoints that move (for example embeddings to another node) must be announced.
