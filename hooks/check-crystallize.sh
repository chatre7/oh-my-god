#!/usr/bin/env bash
# Check if crystallization nudge should be shown after VERIFY phase
# Reads config from stat.md, counts receipts since last crystallize

HOOK_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
STATS="$HOOK_ROOT/stat.md"
RECEIPTS="${PWD}/receipts.md"

# Read nudge setting
nudge=$(grep "^Nudge:" "$STATS" 2>/dev/null | awk '{print $2}')
[ "$nudge" != "on" ] && exit 0

# Read threshold
threshold=$(grep "^Threshold:" "$STATS" 2>/dev/null | awk '{print $2}')
threshold="${threshold:-5}"

# Read last crystallized date
last=$(grep "^Last crystallized:" "$STATS" 2>/dev/null | awk '{print $3}')

# Count receipts since last crystallized
if [ ! -f "$RECEIPTS" ]; then
  exit 0
fi

if [ -z "$last" ] || [ "$last" = "—" ]; then
  count=$(grep -c "^## " "$RECEIPTS" 2>/dev/null || echo 0)
else
  count=$(grep "^## " "$RECEIPTS" | awk -F'[| ]+' '{print $2}' | awk -v d="$last" '$0 > d' | wc -l | tr -d ' ')
fi

# Show nudge if threshold met
if [ "$count" -ge "$threshold" ]; then
  echo ""
  echo "  💡 $count receipts since last crystallize — run /crystallize to distill lessons into SKILL.md"
fi
