#!/usr/bin/env bash
# oh-my-god log-skill hook
# Usage: bash hooks/log-skill.sh <skill-name>
# Increments skill count and updates last-used date in stat.md

HOOK_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
STATS="$HOOK_ROOT/stat.md"
SKILL_NAME="${1:-}"
TODAY=$(date +%Y-%m-%d)

if [ -z "$SKILL_NAME" ]; then
  echo "Usage: bash hooks/log-skill.sh <skill-name>"
  echo ""
  echo "Available skills:"
  grep "^| " "$STATS" | grep -v "^| Skill" | grep -v "^| ---" | awk -F'|' '{gsub(/^ +| +$/,"",$2); print "  "$2}'
  exit 1
fi

if [ ! -f "$STATS" ]; then
  echo "Error: stat.md not found at $STATS"
  exit 1
fi

# Check skill exists in table
if ! grep -q "^| $SKILL_NAME " "$STATS"; then
  echo "Error: skill '$SKILL_NAME' not found in stat.md"
  exit 1
fi

# Get current count and increment
current_count=$(grep "^| $SKILL_NAME " "$STATS" | awk -F'|' '{gsub(/ /,"",$3); print $3+0}')
new_count=$((current_count + 1))

# Update the row: replace count and last-used date
sed -i "s/^| $SKILL_NAME |.*$/| $SKILL_NAME | $new_count | $TODAY |/" "$STATS"

# Update "Last updated" header
sed -i "s/^Last updated: .*/Last updated: $TODAY/" "$STATS"

echo "Logged: $SKILL_NAME — $new_count use(s), last used $TODAY"
