#!/usr/bin/env bash
# View tool call traces — pure bash, no LLM
# Usage: bash hooks/trace-view.sh [YYYY-MM-DD]

TRACES_DIR="${PWD}/traces"
DATE="${1:-$(date +%Y-%m-%d)}"
FILE="$TRACES_DIR/$DATE.jsonl"

if [ ! -f "$FILE" ]; then
  echo "No traces for $DATE"
  exit 0
fi

total=$(wc -l < "$FILE" | tr -d ' ')

echo ""
echo "━━━ Traces: $DATE ($total calls) ━━━━━━━━━━━━━━━━━━━━"
echo ""

# Tool usage summary
echo "Summary:"
while IFS= read -r line; do
  echo "$line" | grep -o '"tool":"[^"]*"' | awk -F'"' '{print $4}'
done < "$FILE" | sort | uniq -c | sort -rn | awk '{printf "  %-20s %s calls\n", $2, $1}'

echo ""
echo "Timeline:"
while IFS= read -r line; do
  ts=$(echo "$line"  | grep -o '"ts":"[^"]*"'    | awk -F'"' '{print $4}' | cut -c12-19)
  tool=$(echo "$line" | grep -o '"tool":"[^"]*"'  | awk -F'"' '{print $4}')
  input=$(echo "$line"| grep -o '"input":"[^"]*"' | awk -F'"' '{print $4}')
  printf "  %s  %-12s %s\n" "$ts" "$tool" "$input"
done < "$FILE"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
