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

# Strip namespace prefix (e.g. "superpowers:brainstorming" → "brainstorming")
SKILL_NAME="${SKILL_NAME##*:}"

# Fuzzy match: find first row containing the skill name as a substring
matched_row=$(grep "^| " "$STATS" | grep -v "^| Skill" | grep -v "^| ---" | awk -F'|' -v s="$SKILL_NAME" 'tolower($2) ~ tolower(s)' | head -1)

if [ -z "$matched_row" ]; then
  # Not tracked in stat.md — skip silently
  exit 0
fi

# Extract exact skill name from matched row
exact_name=$(echo "$matched_row" | awk -F'|' '{gsub(/^ +| +$/,"",$2); print $2}')

# Get current count and increment
current_count=$(echo "$matched_row" | awk -F'|' '{gsub(/ /,"",$3); print $3+0}')
new_count=$((current_count + 1))

# Update the row: replace count and last-used date
sed -i "s/^| $exact_name |.*$/| $exact_name | $new_count | $TODAY |/" "$STATS"

# Update "Last updated" header
sed -i "s/^Last updated: .*/Last updated: $TODAY/" "$STATS"

echo "Logged: $exact_name — $new_count use(s), last used $TODAY"
