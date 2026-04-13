#!/usr/bin/env bash
# Move receipts older than 30 days into [ARCHIVED] section
# Safe to run repeatedly — idempotent

RECEIPTS="${PWD}/receipts.md"
[ -f "$RECEIPTS" ] || exit 0

CUTOFF=$(python3 -c "
from datetime import date, timedelta
print((date.today() - timedelta(days=30)).isoformat())
" 2>/dev/null)
[ -z "$CUTOFF" ] && exit 0

# Check if there are any old entries to move (avoid rewriting file unnecessarily)
old_count=$(grep "^## " "$RECEIPTS" | awk -F'[| ]+' '{print $2}' | awk -v c="$CUTOFF" '$0 < c && $0 ~ /^[0-9]{4}/' | wc -l | tr -d ' ')
[ "$old_count" -eq 0 ] && exit 0

python3 - "$RECEIPTS" "$CUTOFF" <<'EOF'
import sys, re
from pathlib import Path

path = Path(sys.argv[1])
cutoff = sys.argv[2]
content = path.read_text(encoding='utf-8')

# Split into blocks by "## " headers
blocks = re.split(r'(?=^## )', content, flags=re.MULTILINE)
header_block = blocks[0] if not blocks[0].startswith('## ') else ''
receipt_blocks = [b for b in blocks if b.startswith('## ')]

active, archived_existing, new_archived = [], [], []

# Separate existing archived section
for b in receipt_blocks:
    if b.strip() == '## [ARCHIVED]':
        continue
    if '## [ARCHIVED]' in b:
        # Split at [ARCHIVED] marker
        parts = b.split('## [ARCHIVED]', 1)
        if parts[0].strip():
            active.append(parts[0])
        archived_existing = [parts[1]] if parts[1].strip() else []
    else:
        m = re.match(r'^## (\d{4}-\d{2}-\d{2})', b)
        if m and m.group(1) < cutoff:
            new_archived.append(b)
        else:
            active.append(b)

all_archived = new_archived + archived_existing
result = header_block + ''.join(active)
if all_archived:
    result += '\n## [ARCHIVED]\n\n' + ''.join(all_archived)

path.write_text(result, encoding='utf-8')
print(f"Archived {len(new_archived)} receipt(s) older than {cutoff}")
EOF
