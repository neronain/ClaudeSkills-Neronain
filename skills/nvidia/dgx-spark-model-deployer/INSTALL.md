# Install

Keep exactly one copy: this directory in the ClaudeSkills-Neronain repo. On the owner's Mac the installed skill is a symlink to it, so edits and `git pull` take effect without a reinstall:

```bash
rm -rf ~/.claude/skills/dgx-spark-model-deployer && ln -s ~/claude/ClaudeSkills-Neronain/skills/nvidia/dgx-spark-model-deployer ~/.claude/skills/dgx-spark-model-deployer
```

`./scripts/link-skills.sh --force` never overwrites that symlink. On other machines `link-skills.sh` copies the skill instead; run it again after pulling.

Do not keep other copies — cc-switch's skill store, the old v3 team packs and zips. They drift, and v3 teaches hand-written controllers that skip LMDS's fixes.

Check it, then restart Claude Code:

```bash
python3 ~/.claude/skills/dgx-spark-model-deployer/scripts/validate_skill.py
python3 ~/.claude/skills/dgx-spark-model-deployer/scripts/check_lmds_commands.py
```

`check_lmds_commands.py` needs `lmds` on PATH or the `Autodeploy` OrbStack VM.
