#!/usr/bin/env bash
# oh-my-god session-start hook
# Prints project context so the agent knows where things left off

HOOK_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RECEIPTS="$HOOK_ROOT/receipts.md"
STATS="$HOOK_ROOT/stat.md"
SPECS_DIR="$HOOK_ROOT/docs/specs"

# --- Last receipt ---
last_receipt=""
if [ -f "$RECEIPTS" ]; then
  last_receipt=$(grep "^## " "$RECEIPTS" | tail -1 | sed 's/^## //')
fi

# --- Latest spec ---
latest_spec=""
if [ -d "$SPECS_DIR" ]; then
  latest_spec=$(ls -t "$SPECS_DIR"/*.md 2>/dev/null | head -1)
  latest_spec=$(basename "$latest_spec" 2>/dev/null)
fi

# --- Top 3 skills from stat.md ---
top_skills=""
if [ -f "$STATS" ]; then
  top_skills=$(grep "^| " "$STATS" \
    | grep -v "^| Skill" \
    | grep -v "^| ---" \
    | awk -F'|' '{gsub(/ /,"",$2); gsub(/ /,"",$3); if($3+0>0) print $3+0, $2}' \
    | sort -rn \
    | head -3 \
    | awk '{print $2"("$1"x)"}' \
    | paste -sd', ' -)
fi

# --- Print context block ---
echo ""
echo "━━━ oh-my-god | Session Resume ━━━━━━━━━━━━━━━━━━━━━"
if [ -n "$last_receipt" ]; then
  echo "  Last receipt: $last_receipt"
else
  echo "  Last receipt: none"
fi
if [ -n "$latest_spec" ]; then
  echo "  Open spec:    $latest_spec"
else
  echo "  Open spec:    none"
fi
if [ -n "$top_skills" ]; then
  echo "  Top skills:   $top_skills"
fi
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
