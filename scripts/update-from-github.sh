#!/bin/bash
# Script to update skills from GitHub repositories
# Usage: ./update-from-github.sh

set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CACHE_DIR="/tmp/claude-skills-update"

echo "=== ClaudeSkills-Neronain: Update from GitHub ==="
echo ""

# Create cache directory
mkdir -p "$CACHE_DIR"

# Function to clone/update a repo
clone_or_update() {
    local repo_url="$1"
    local repo_name="$2"
    local branch="${3:-main}"
    
    echo "Fetching $repo_name..."
    
    if [ -d "$CACHE_DIR/$repo_name" ]; then
        cd "$CACHE_DIR/$repo_name"
        git fetch origin
        git checkout "$branch"
        git pull origin "$branch"
    else
        git clone "$repo_url" "$CACHE_DIR/$repo_name" --branch "$branch" --depth 1
    fi
}

# Function to copy skills from cloned repo
copy_skills() {
    local src_dir="$1"
    local dest_dir="$2"
    local skills_pattern="${3:-SKILL.md}"
    
    if [ -d "$src_dir" ]; then
        echo "  Copying skills from $src_dir..."
        cp -r "$src_dir"/* "$dest_dir/" 2>/dev/null || true
    fi
}

# Clone repositories
echo "Cloning repositories..."
clone_or_update "https://github.com/ComposioHQ/awesome-claude-skills.git" "awesome-claude-skills"
clone_or_update "https://github.com/davila7/claude-code-templates.git" "claude-code-templates"
clone_or_update "https://github.com/VoltAgent/awesome-claude-code-subagents.git" "awesome-claude-code-subagents"
clone_or_update "https://github.com/rohitg00/awesome-claude-code-toolkit.git" "awesome-claude-code-toolkit"
clone_or_update "https://github.com/anthropics/claude-code.git" "claude-code"
clone_or_update "https://github.com/gsd-build/get-shit-done.git" "get-shit-done"
clone_or_update "https://github.com/FlorianBruniaux/claude-code-ultimate-guide.git" "claude-code-ultimate-guide"
clone_or_update "https://github.com/affaan-m/ECC.git" "ECC"
clone_or_update "https://github.com/shareAI-lab/learn-claude-code.git" "learn-claude-code"

echo ""
echo "Update complete!"
echo ""
echo "You can now manually review and copy skills from:"
echo "  $CACHE_DIR/"
echo ""
