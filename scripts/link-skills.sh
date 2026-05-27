#!/bin/bash
# Link skills from ClaudeSkills-Neronain to ~/.claude/skills

set -e

SKILLS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/skills"
AGENTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/agents"
CLAUDE_DIR="$HOME/.claude"

echo "=== Linking ClaudeSkills-Neronain Skills ==="
echo ""

# Link skills directory
if [ -d "$SKILLS_DIR" ]; then
    echo "Creating skills symlink..."
    mkdir -p "$CLAUDE_DIR/skills"
    for skill_dir in "$SKILLS_DIR"/*/; do
        skill_name=$(basename "$skill_dir")
        # Skip directories that are already linked or are README files
        if [ -f "$skill_dir/SKILL.md" ] || [ -d "$skill_dir" ]; then
            # Create a directory in skills for the skill
            if [ ! -L "$CLAUDE_DIR/skills/$skill_name" ] && [ ! -d "$CLAUDE_DIR/skills/$skill_name" ]; then
                mkdir -p "$CLAUDE_DIR/skills/$skill_name"
                # Copy SKILL.md if exists
                if [ -f "$skill_dir/SKILL.md" ]; then
                    cp "$skill_dir/SKILL.md" "$CLAUDE_DIR/skills/$skill_name/SKILL.md"
                    echo "  Linked: $skill_name"
                fi
                # Copy README.md if exists
                if [ -f "$skill_dir/README.md" ]; then
                    cp "$skill_dir/README.md" "$CLAUDE_DIR/skills/$skill_name/README.md"
                fi
            fi
        fi
    done
fi

# Link agents
if [ -d "$AGENTS_DIR" ]; then
    echo ""
    echo "Creating agents symlink..."
    mkdir -p "$CLAUDE_DIR/agents"
    for agent_file in "$AGENTS_DIR"/*.md; do
        if [ -f "$agent_file" ]; then
            agent_name=$(basename "$agent_file" .md)
            if [ ! -L "$CLAUDE_DIR/agents/$agent_name.md" ] && [ ! -f "$CLAUDE_DIR/agents/$agent_name.md" ]; then
                cp "$agent_file" "$CLAUDE_DIR/agents/$agent_name.md"
                echo "  Linked: $agent_name"
            fi
        fi
    done
fi

echo ""
echo "Done! Restart Claude Code to see the new skills."
