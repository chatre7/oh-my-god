#!/usr/bin/env bash
# PostToolUse hook — log tool calls to traces/YYYY-MM-DD.jsonl
# Pure bash + grep/awk — no python3, minimal overhead

TRACES_DIR="${PWD}/traces"
TIMESTAMP=$(date +%Y-%m-%dT%H:%M:%S)
TODAY=$(date +%Y-%m-%d)

input=$(cat)

# Extract tool name
tool=$(echo "$input" | grep -o '"tool_name":"[^"]*"' | awk -F'"' '{print $4}' | head -1)

# Filter: skip noisy/meta tools
case "$tool" in
  Read|Write|Edit|Bash|Glob|Grep|Agent|Skill|WebFetch|WebSearch) ;;
  *) exit 0 ;;
esac

# Extract key input field per tool type
case "$tool" in
  Read|Write|Edit)
    key=$(echo "$input" | grep -o '"file_path":"[^"]*"' | awk -F'"' '{print $4}' | head -1)
    ;;
  Bash)
    key=$(echo "$input" | grep -o '"command":"[^"]*"' | awk -F'"' '{print $4}' | head -1)
    key="${key:0:120}"
    ;;
  Glob)
    key=$(echo "$input" | grep -o '"pattern":"[^"]*"' | awk -F'"' '{print $4}' | head -1)
    ;;
  Grep)
    key=$(echo "$input" | grep -o '"pattern":"[^"]*"' | awk -F'"' '{print $4}' | head -1)
    ;;
  Agent)
    key=$(echo "$input" | grep -o '"description":"[^"]*"' | awk -F'"' '{print $4}' | head -1)
    key="${key:0:100}"
    ;;
  Skill)
    key=$(echo "$input" | grep -o '"skill":"[^"]*"' | awk -F'"' '{print $4}' | head -1)
    ;;
  WebFetch)
    key=$(echo "$input" | grep -o '"url":"[^"]*"' | awk -F'"' '{print $4}' | head -1)
    ;;
  WebSearch)
    key=$(echo "$input" | grep -o '"query":"[^"]*"' | awk -F'"' '{print $4}' | head -1)
    ;;
esac

mkdir -p "$TRACES_DIR"
echo "{\"ts\":\"$TIMESTAMP\",\"tool\":\"$tool\",\"input\":\"$key\"}" >> "$TRACES_DIR/$TODAY.jsonl"
