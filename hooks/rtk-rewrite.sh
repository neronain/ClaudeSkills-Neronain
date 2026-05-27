#!/bin/bash
# RTK Rewrite Hook - Automatically wraps bash commands with RTK for token savings
# Usage: Configure in settings.json as PreToolUse hook for Bash

# Commands to exclude from RTK rewriting (raw execution only)
EXCLUDED_COMMANDS="npm install|npm run|yarn install|yarn run|git commit|git push|git push --force|sudo|ssh|scp|rsync|eval|source|exec"

# Get the full command line
if [ -z "$CLAUDE_CODE_INPUT" ]; then
    echo "$@"
    exit 0
fi

CMD="$CLAUDE_CODE_INPUT"

# If command is excluded, execute raw
if echo "$CMD" | grep -Eq "^($EXCLUDED_COMMANDS)"; then
    echo "$CMD"
    exit 0
fi

# Map known commands to their RTK equivalents
declare -A COMMAND_MAP=(
    ["git status"]="rtk git status"
    ["git log"]="rtk git log"
    ["git diff"]="rtk git diff"
    ["npm list"]="rtk pnpm list"
    ["pnpm list"]="rtk pnpm list"
    ["yarn list"]="rtk pnpm list"
    ["ls"]="rtk ls"
    ["find"]="rtk find"
    ["docker ps"]="rtk docker ps"
    ["kubectl get"]="rtk kubectl get"
)

# Simple command mapping
BASE_CMD=$(echo "$CMD" | awk '{print $1}')

for key in "${!COMMAND_MAP[@]}"; do
    KEY_BASE=$(echo "$key" | awk '{print $1}')
    if [ "$BASE_CMD" = "$KEY_BASE" ]; then
        echo "${COMMAND_MAP[$key]} ${CMD#$KEY_BASE }"
        exit 0
    fi
done

# Default: pass through for unknown commands
echo "$CMD"
exit 0
