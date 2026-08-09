#!/usr/bin/env bash
# Install skills, agents, and commands from ClaudeSkills-Neronain into ~/.claude/
#
# Usage: ./scripts/link-skills.sh [--force] [--dry-run]
#   --force    overwrite existing files (use after `git pull`)
#   --dry-run  show what would happen, change nothing
#
# Layout it understands:
#   skills/<name>/SKILL.md              -> ~/.claude/skills/<name>/
#   skills/<bucket>/<name>/SKILL.md     -> ~/.claude/skills/<name>/
#   skills/<name>.md                    -> ~/.claude/skills/<name>/SKILL.md
#   agents/*.md                         -> ~/.claude/agents/
#   commands/*.md                       -> ~/.claude/commands/
#
# A directory is treated as a BUCKET (engineering/, nvidia/, ...) when it has no
# SKILL.md of its own but contains children that do. No hardcoded bucket list.
#
# Whole skill directories are copied, so nested references/ and scripts/ survive.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CLAUDE_DIR="${CLAUDE_HOME:-$HOME/.claude}"
SKILLS_SRC="$REPO_DIR/skills"
AGENTS_SRC="$REPO_DIR/agents"
COMMANDS_SRC="$REPO_DIR/commands"

FORCE=false
DRY=false
for arg in "$@"; do
  case "$arg" in
    --force)   FORCE=true ;;
    --dry-run) DRY=true ;;
    -h|--help) sed -n '2,20p' "$0"; exit 0 ;;
    *) echo "unknown flag: $arg" >&2; exit 2 ;;
  esac
done

installed=0; updated=0; skipped=0

say() { printf '  %s\n' "$*"; }

# A skill dir is one containing SKILL.md / skill.md (case varies across authors,
# and Linux is case-sensitive where macOS is not).
has_skill() { [ -f "$1/SKILL.md" ] || [ -f "$1/skill.md" ]; }

# copy_tree SRC_DIR DEST_DIR LABEL
copy_tree() {
  local src="$1" dest="$2" label="$3"
  if [ -e "$dest" ] && [ "$FORCE" = false ]; then
    skipped=$((skipped + 1)); return
  fi
  if [ "$DRY" = true ]; then
    say "would install $label"
  else
    # Never clobber a symlink the user set up on purpose (e.g. -> ~/9arm-skills).
    if [ -L "$dest" ]; then
      say "skip $label (symlink to $(readlink "$dest"))"
      skipped=$((skipped + 1)); return
    fi
    rm -rf "$dest"
    cp -R "$src" "$dest"
  fi
  if [ -e "$dest" ] && [ "$FORCE" = true ]; then
    updated=$((updated + 1)); say "update $label"
  else
    installed=$((installed + 1)); say "install $label"
  fi
}

# copy_file SRC DEST LABEL
copy_file() {
  local src="$1" dest="$2" label="$3"
  if [ -f "$dest" ] && [ "$FORCE" = false ]; then
    skipped=$((skipped + 1)); return
  fi
  if [ "$DRY" = true ]; then
    say "would install $label"; installed=$((installed + 1)); return
  fi
  cp "$src" "$dest"
  if [ "$FORCE" = true ]; then updated=$((updated + 1)); say "update $label"
  else installed=$((installed + 1)); say "install $label"; fi
}

echo "=== ClaudeSkills-Neronain install ==="
echo "repo   : $REPO_DIR"
echo "target : $CLAUDE_DIR"
echo "force  : $FORCE   dry-run: $DRY"
echo

# ---------- Skills ----------
echo "[skills]"
mkdir -p "$CLAUDE_DIR/skills"

install_skill_dir() {
  local src="$1" name; name="$(basename "$1")"
  copy_tree "$src" "$CLAUDE_DIR/skills/$name" "skill $name"
}

for item in "$SKILLS_SRC"/*/; do
  [ -d "$item" ] || continue
  if has_skill "${item%/}"; then
    install_skill_dir "${item%/}"
  else
    # bucket: recurse one level
    for child in "$item"*/; do
      [ -d "$child" ] && has_skill "${child%/}" || continue
      install_skill_dir "${child%/}"
    done
  fi
done

# bare .md skills at skills/ root
for f in "$SKILLS_SRC"/*.md; do
  [ -f "$f" ] || continue
  name="$(basename "$f" .md)"
  [ "$name" = "README" ] && continue
  dest_dir="$CLAUDE_DIR/skills/$name"
  [ "$DRY" = true ] || mkdir -p "$dest_dir"
  copy_file "$f" "$dest_dir/SKILL.md" "skill $name (flat .md)"
done

# ---------- Agents ----------
echo
echo "[agents]"
[ "$DRY" = true ] || mkdir -p "$CLAUDE_DIR/agents"
for f in "$AGENTS_SRC"/*.md; do
  [ -f "$f" ] || continue
  name="$(basename "$f")"
  [ "$name" = "README.md" ] && continue
  copy_file "$f" "$CLAUDE_DIR/agents/$name" "agent ${name%.md}"
done

# ---------- Commands ----------
echo
echo "[commands]"
[ "$DRY" = true ] || mkdir -p "$CLAUDE_DIR/commands"
if [ -d "$COMMANDS_SRC" ]; then
  for f in "$COMMANDS_SRC"/*.md; do
    [ -f "$f" ] || continue
    name="$(basename "$f")"
    [ "$name" = "README.md" ] && continue
    copy_file "$f" "$CLAUDE_DIR/commands/$name" "command ${name%.md}"
  done
fi

echo
echo "=== done ==="
echo "  installed : $installed"
echo "  updated   : $updated"
echo "  skipped   : $skipped   (re-run with --force to overwrite)"
echo
echo "The RTK hook is NOT installed by this script — see INSTALL.md step 3."
echo "Restart Claude Code to load new skills, agents, and commands."
