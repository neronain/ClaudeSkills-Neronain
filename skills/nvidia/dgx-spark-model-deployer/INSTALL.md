# Install

Keep exactly one copy: this directory in the ClaudeSkills-Neronain repo. On the owner's Mac the installed skill is a symlink to it, so edits and `git pull` take effect without a reinstall:

```bash
rm -rf ~/.claude/skills/dgx-spark-model-deployer && ln -s ~/claude/ClaudeSkills-Neronain/skills/nvidia/dgx-spark-model-deployer ~/.claude/skills/dgx-spark-model-deployer
```

`./scripts/link-skills.sh --force` never overwrites that symlink. On other machines `link-skills.sh` copies the skill instead; run it again after pulling.

Do not keep other copies — cc-switch's skill store, the old v3 team packs and zips. They drift, and v3 teaches hand-written controllers that skip LMDS's fixes.

## OpenClaw on a node

OpenClaw loads skills from `~/.openclaw/workspace/skills`. Ship this directory there from the Mac through the hub, replacing it whole, under the same directory name so the node never holds two versions:

```bash
COPYFILE_DISABLE=1 tar --no-xattrs --exclude=__pycache__ -C ~/claude/ClaudeSkills-Neronain/skills/nvidia -czf - dgx-spark-model-deployer | orb -m Autodeploy bash -lc 'ssh -i ~/.config/lmds/id_lmds neronain@<node-ip> "rm -rf ~/.openclaw/workspace/skills/dgx-spark-model-deployer && tar -xzf - -C ~/.openclaw/workspace/skills"'
```

Installed on dgx-spark04 (2026-09-14). Re-run the command after every change here.

Check it, then restart Claude Code:

```bash
python3 ~/.claude/skills/dgx-spark-model-deployer/scripts/validate_skill.py
python3 ~/.claude/skills/dgx-spark-model-deployer/scripts/check_lmds_commands.py
```

`check_lmds_commands.py` needs `lmds` on PATH or the `Autodeploy` OrbStack VM.
