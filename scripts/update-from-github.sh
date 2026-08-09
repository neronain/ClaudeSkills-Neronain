#!/usr/bin/env bash
# Pull vendored skills back in from their upstream repos, then refresh the docs.
#
# Usage: ./scripts/update-from-github.sh [--refs]
#   (no flag)  sync the skills this repo actually vendors  (9arm-skills)
#   --refs     additionally clone the read-only reference repos into a cache dir
#              for browsing; nothing is copied from them automatically
#
# After this runs, review `git diff` before committing — upstream owns those files
# and a blind copy can revert a local fix you meant to send upstream instead.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CACHE_DIR="${CACHE_DIR:-${TMPDIR:-/tmp}/claude-skills-refs}"

# upstream repo -> local checkout -> which bucket its subfolders map to
NINEARM_REMOTE="https://github.com/thananon/9arm-skills.git"
NINEARM_LOCAL="${NINEARM_LOCAL:-$HOME/9arm-skills}"

echo "=== sync vendored skills ==="

if [ -d "$NINEARM_LOCAL/.git" ]; then
  echo "9arm-skills: $NINEARM_LOCAL"
  git -C "$NINEARM_LOCAL" pull --ff-only
else
  echo "9arm-skills: cloning into $NINEARM_LOCAL"
  git clone "$NINEARM_REMOTE" "$NINEARM_LOCAL"
fi

copied=0
for bucket in engineering productivity; do
  src="$NINEARM_LOCAL/skills/$bucket"
  [ -d "$src" ] || continue
  mkdir -p "$REPO_DIR/skills/$bucket"
  for skill in "$src"/*/; do
    [ -d "$skill" ] || continue
    name="$(basename "$skill")"
    rm -rf "${REPO_DIR:?}/skills/$bucket/$name"
    cp -R "$skill" "$REPO_DIR/skills/$bucket/$name"
    echo "  $bucket/$name"
    copied=$((copied + 1))
  done
done
echo "$copied vendored skills refreshed"

echo
echo "=== regenerate docs ==="
"$REPO_DIR/scripts/gen-docs.py"

echo
echo "Review before committing:"
echo "  git -C $REPO_DIR diff --stat"

# ---------------------------------------------------------------------------
if [[ " $* " == *" --refs "* ]]; then
  echo
  echo "=== reference repos (browse only, nothing is copied) ==="
  mkdir -p "$CACHE_DIR"
  refs=(
    "https://github.com/anthropics/claude-code.git"
    "https://github.com/ComposioHQ/awesome-claude-skills.git"
    "https://github.com/VoltAgent/awesome-claude-code-subagents.git"
    "https://github.com/rohitg00/awesome-claude-code-toolkit.git"
    "https://github.com/davila7/claude-code-templates.git"
    "https://github.com/FlorianBruniaux/claude-code-ultimate-guide.git"
    "https://github.com/shareAI-lab/learn-claude-code.git"
    "https://github.com/gsd-build/get-shit-done.git"
  )
  for url in "${refs[@]}"; do
    name="$(basename "$url" .git)"
    if [ -d "$CACHE_DIR/$name/.git" ]; then
      echo "  update $name"
      git -C "$CACHE_DIR/$name" pull --ff-only --quiet || echo "    (skipped: local changes)"
    else
      echo "  clone  $name"
      git clone --depth 1 --quiet "$url" "$CACHE_DIR/$name"
    fi
  done
  echo
  echo "Browse: $CACHE_DIR"
fi
