#!/usr/bin/env bash
# oh-my-god session-start hook
# Prints project context so the agent knows where things left off

HOOK_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROJECT_ROOT="${PWD}"
RECEIPTS="$PROJECT_ROOT/receipts.md"
STATS="$HOOK_ROOT/stat.md"
SPECS_DIR="$PROJECT_ROOT/docs/specs"

# --- Last receipt + age ---
last_receipt=""
receipt_age=""
if [ -f "$RECEIPTS" ]; then
  last_receipt=$(grep "^## " "$RECEIPTS" | tail -1 | sed 's/^## //')

  # Extract date from receipt line (format: YYYY-MM-DD ...)
  receipt_date=$(echo "$last_receipt" | grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}')
  if [ -n "$receipt_date" ]; then
    now=$(date +%s)
    then=$(date -d "$receipt_date" +%s 2>/dev/null || date -j -f "%Y-%m-%d" "$receipt_date" +%s 2>/dev/null)
    if [ -n "$then" ]; then
      diff_days=$(( (now - then) / 86400 ))
      if [ "$diff_days" -eq 0 ]; then
        receipt_age="today"
      elif [ "$diff_days" -eq 1 ]; then
        receipt_age="1 day ago"
      else
        receipt_age="${diff_days} days ago"
      fi
    fi
  fi
fi

# --- Latest spec ---
latest_spec=""
if [ -d "$SPECS_DIR" ]; then
  latest_spec=$(ls -t "$SPECS_DIR"/*.md 2>/dev/null | grep -v "README" | head -1)
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
  if [ -n "$receipt_age" ]; then
    echo "  Last receipt: $last_receipt ($receipt_age)"
  else
    echo "  Last receipt: $last_receipt"
  fi
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
