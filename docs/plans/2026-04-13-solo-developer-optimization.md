# Solo Developer Optimization — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [x]`) syntax for tracking.

**Goal:** ปรับ oh-my-god ให้เหมาะกับ solo developer — Express mode by default, lightweight receipts, session-start hook, และ skill usage tracking

**Architecture:** แก้ไข SKILL.md สำหรับ behavior changes, สร้าง shell hook สำหรับ session resume, และสร้าง markdown files สำหรับ tracking

**Tech Stack:** Bash (hooks), Markdown (skills/receipts/stats)

---

### Task 1: Express Mode Default + Lightweight Receipt

**Files:**
- Modify: `.agents/skills/oh-my-god/SKILL.md`

- [x] **Step 1: เพิ่ม Express Mode default หลัง Platform Support table**

เปิดไฟล์ `.agents/skills/oh-my-god/SKILL.md` หา section `## FIVE IRON LAWS` แล้วเพิ่ม block นี้ก่อนหน้า:

```markdown
## DEFAULT MODE: EXPRESS

Solo developer mode — active by default.

- Zero approval prompts between phases
- Only one gate remains: HARD GATE before BUILD (design must be approved)
- All other phase transitions happen automatically

To switch modes, say: "use Thorough mode" or "use Meticulous mode"
```

- [x] **Step 2: แก้ receipt format ใน Phase 4 BUILD**

หา section `### Per-Task Receipt` ใน SKILL.md แล้วแทนที่ JSON block ด้วย:

```markdown
### Per-Task Receipt

Append to `receipts.md` in the project root:

```markdown
## [YYYY-MM-DD HH:MM] | BUILD | [Task name]
- [x] Tests written and watched fail first (RED verified)
- [x] All tests pass — [command output: N/N]
- [x] No scope creep — touched only specified files
- [x] Committed — [commit hash or message]
```

If `receipts.md` does not exist, create it with header:
```markdown
# oh-my-god | Receipts
```
```

- [x] **Step 3: แก้ Final Receipt section**

หา `## FINAL RECEIPT (on skill completion)` แทนที่ JSON block ด้วย:

```markdown
## FINAL RECEIPT

Append to `receipts.md`:

```markdown
## [YYYY-MM-DD HH:MM] | COMPLETE | [Mode]
- [x] All phases completed
- [x] Tests passing: [N/N]
- [x] Security checklist verified
- [x] Spec criteria met line-by-line
```
```

- [x] **Step 4: Verify**

อ่าน `.agents/skills/oh-my-god/SKILL.md` ตรวจว่า:
- มี `## DEFAULT MODE: EXPRESS` section ก่อน Iron Laws
- Per-Task Receipt เป็น markdown checklist ไม่ใช่ JSON
- Final Receipt เป็น markdown checklist ไม่ใช่ JSON

---

### Task 2: สร้าง stat.md

**Files:**
- Create: `stat.md`

- [x] **Step 1: สร้าง stat.md ที่ root**

```markdown
# oh-my-god | Skill Usage Stats

Last updated: —

| Skill | Uses | Last used |
|-------|------|-----------|
| oh-my-god | 0 | — |
| brainstorming | 0 | — |
| test-driven-development | 0 | — |
| systematic-debugging | 0 | — |
| verification-before-completion | 0 | — |
| spec-driven-development | 0 | — |
| planning-and-task-breakdown | 0 | — |
| incremental-implementation | 0 | — |
| subagent-driven-development | 0 | — |
| writing-plans | 0 | — |
| code-review-and-quality | 0 | — |
| security-and-hardening | 0 | — |
| git-workflow-and-versioning | 0 | — |
| shipping-and-launch | 0 | — |
| context-engineering | 0 | — |

---

## How to update

When using a skill, update the count and date manually or via session-start hook:

1. Find the skill row
2. Increment Uses by 1
3. Set Last used to today's date (YYYY-MM-DD)
4. Update "Last updated" at the top
```

- [x] **Step 2: Verify**

ตรวจว่า `stat.md` อยู่ที่ root และมี table ครบ

---

### Task 3: สร้าง session-start hook script

**Files:**
- Create: `hooks/session-start.sh`

- [x] **Step 1: สร้าง hooks/ directory และ session-start.sh**

```bash
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
```

- [x] **Step 2: ทำให้ script executable**

```bash
chmod +x hooks/session-start.sh
```

- [x] **Step 3: Verify — รัน script ทดสอบ**

```bash
bash hooks/session-start.sh
```

Expected output (ถ้ายังไม่มี receipts.md และ specs):
```
━━━ oh-my-god | Session Resume ━━━━━━━━━━━━━━━━━━━━━
  Last receipt: none
  Open spec:    none
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

### Task 4: Register hook ใน hooks.json

**Files:**
- Create: `hooks/hooks.json`

- [x] **Step 1: สร้าง hooks/hooks.json**

```json
{
  "description": "oh-my-god session hooks",
  "hooks": {
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash \"${CLAUDE_PLUGIN_ROOT}/hooks/session-start.sh\"",
            "timeout": 10
          }
        ]
      }
    ]
  }
}
```

- [x] **Step 2: Verify โครงสร้าง hooks/**

```bash
ls hooks/
```

Expected:
```
hooks.json
session-start.sh
```

- [x] **Step 3: Verify hooks.json syntax**

```bash
python3 -c "import json,sys; json.load(open('hooks/hooks.json')); print('valid JSON')"
```

Expected: `valid JSON`

---

## Checkpoint: หลังทำครบทั้ง 4 tasks

- [x] `.agents/skills/oh-my-god/SKILL.md` มี Express Mode section และ receipt เป็น markdown
- [x] `stat.md` อยู่ที่ root มี table ครบ
- [x] `hooks/session-start.sh` รันได้ output ถูกต้อง
- [x] `hooks/hooks.json` เป็น valid JSON
- [x] ไม่มีไฟล์อื่นถูกแตะโดยไม่จำเป็น
