#!/bin/bash
# Install skills, agents, and commands from ClaudeSkills-Neronain to ~/.claude/
# Usage: ./link-skills.sh [--force]
#   --force: overwrite existing files (use after repo updates)

set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILLS_DIR="$REPO_DIR/skills"
AGENTS_DIR="$REPO_DIR/agents"
COMMANDS_DIR="$REPO_DIR/commands"
CLAUDE_DIR="$HOME/.claude"
FORCE=false

for arg in "$@"; do
  [ "$arg" = "--force" ] && FORCE=true
done

installed=0
skipped=0
updated=0

install_file() {
  local src="$1"
  local dest="$2"
  if [ -f "$dest" ] && [ "$FORCE" = false ]; then
    skipped=$((skipped + 1))
    return
  fi
  cp "$src" "$dest"
  if [ -f "$dest" ] && [ "$FORCE" = true ]; then
    updated=$((updated + 1))
  else
    installed=$((installed + 1))
  fi
}

install_skill_dir() {
  local src_dir="$1"
  local skill_name="$2"
  local dest_dir="$CLAUDE_DIR/skills/$skill_name"

  if [ ! -f "$src_dir/SKILL.md" ]; then return; fi

  mkdir -p "$dest_dir"
  for f in "$src_dir"/*.md; do
    [ -f "$f" ] || continue
    dest="$dest_dir/$(basename "$f")"
    if [ -f "$dest" ] && [ "$FORCE" = false ]; then
      skipped=$((skipped + 1))
    else
      cp "$f" "$dest"
      installed=$((installed + 1))
    fi
  done
  echo "  skill: $skill_name"
}

echo "=== ClaudeSkills-Neronain Install ==="
echo "Repo: $REPO_DIR"
echo "Force: $FORCE"
echo ""

# --- Skills ---
echo "[Skills]"
mkdir -p "$CLAUDE_DIR/skills"

for item in "$SKILLS_DIR"/*/; do
  [ -d "$item" ] || continue
  bucket=$(basename "$item")

  # Bucket dirs: recurse into their children
  if [[ "$bucket" =~ ^(engineering|productivity|misc|personal|deprecated|in-progress)$ ]]; then
    for child in "$item"*/; do
      [ -d "$child" ] || continue
      install_skill_dir "$child" "$(basename "$child")"
    done
  else
    install_skill_dir "$item" "$bucket"
  fi
done

# Skill .md files at root of skills/
for f in "$SKILLS_DIR"/*.md; do
  [ -f "$f" ] || continue
  name=$(basename "$f" .md)
  dest_dir="$CLAUDE_DIR/skills/$name"
  mkdir -p "$dest_dir"
  dest_file="$dest_dir/SKILL.md"
  if [ -f "$dest_file" ] && [ "$FORCE" = false ]; then
    skipped=$((skipped + 1))
  else
    cp "$f" "$dest_file"
    installed=$((installed + 1))
    echo "  skill: $name (from .md)"
  fi
done

# --- Agents ---
echo ""
echo "[Agents]"
mkdir -p "$CLAUDE_DIR/agents"

for f in "$AGENTS_DIR"/*.md; do
  [ -f "$f" ] || continue
  name=$(basename "$f")
  [ "$name" = "README.md" ] && continue
  dest="$CLAUDE_DIR/agents/$name"
  if [ -f "$dest" ] && [ "$FORCE" = false ]; then
    skipped=$((skipped + 1))
  else
    cp "$f" "$dest"
    installed=$((installed + 1))
    echo "  agent: $(basename "$name" .md)"
  fi
done

# --- Commands ---
echo ""
echo "[Commands]"
mkdir -p "$CLAUDE_DIR/commands"

if [ -d "$COMMANDS_DIR" ]; then
  for f in "$COMMANDS_DIR"/*.md; do
    [ -f "$f" ] || continue
    name=$(basename "$f")
    dest="$CLAUDE_DIR/commands/$name"
    if [ -f "$dest" ] && [ "$FORCE" = false ]; then
      skipped=$((skipped + 1))
    else
      cp "$f" "$dest"
      installed=$((installed + 1))
      echo "  command: $(basename "$name" .md)"
    fi
  done
fi

echo ""
echo "=== Done ==="
echo "  Installed : $installed"
echo "  Updated   : $updated"
echo "  Skipped   : $skipped (run with --force to overwrite)"
echo ""
echo "Restart Claude Code to load new skills and agents."
