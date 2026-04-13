#!/usr/bin/env bash
# PostToolUse hook for Skill tool
# Reads JSON event from stdin, extracts skill name, calls log-skill.sh

HOOK_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

input=$(cat)
skill_name=$(echo "$input" | python3 -c "
import sys, json
try:
    d = json.load(sys.stdin)
    skill = d.get('tool_input', {}).get('skill', '') or d.get('skill', '')
    print(skill)
except Exception:
    print('')
" 2>/dev/null)

[ -n "$skill_name" ] && bash "$HOOK_ROOT/hooks/log-skill.sh" "$skill_name" 2>/dev/null || true
