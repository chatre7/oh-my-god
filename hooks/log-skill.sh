#!/usr/bin/env bash
# oh-my-god log-skill hook
# Usage: bash hooks/log-skill.sh <skill-name>
# Increments skill count and updates last-used date in stat.md

HOOK_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
STATS="$HOOK_ROOT/stat.md"
SKILL_NAME="${1:-}"
OUTCOME="${2:-}"  # optional: "success" or "rollback"
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

# Parse current row columns: | name | uses | ✓ | ✗ | score | last |
uses=$(echo "$matched_row"    | awk -F'|' '{gsub(/ /,"",$3); print $3+0}')
success=$(echo "$matched_row" | awk -F'|' '{gsub(/ /,"",$4); print $4+0}')
rollback=$(echo "$matched_row"| awk -F'|' '{gsub(/ /,"",$5); print $5+0}')

new_uses=$(( uses + 1 ))

# Update outcome columns
if [ "$OUTCOME" = "success" ]; then
  success=$(( success + 1 ))
elif [ "$OUTCOME" = "rollback" ]; then
  rollback=$(( rollback + 1 ))
fi

# Recalculate score
total=$(( success + rollback ))
if [ "$total" -gt 0 ]; then
  score=$(python3 -c "print(f'{round($success/$total*100)}%')")
else
  score="—"
fi

# Update the row and header (python3 — avoids sed -i portability issues on macOS)
python3 - "$STATS" "$exact_name" "$new_uses" "$success" "$rollback" "$score" "$TODAY" <<'EOF'
import sys, re
path, name, uses, success, rollback, score, today = sys.argv[1:]
content = open(path, encoding='utf-8').read()
content = re.sub(
    r'^\| ' + re.escape(name) + r' \|.*$',
    f'| {name} | {uses} | {success} | {rollback} | {score} | {today} |',
    content, flags=re.MULTILINE
)
content = re.sub(r'^Last updated: .*', f'Last updated: {today}', content, flags=re.MULTILINE)
open(path, 'w', encoding='utf-8').write(content)
EOF

echo "Logged: $exact_name — ${new_uses}x, score=${score}, last used $TODAY"
