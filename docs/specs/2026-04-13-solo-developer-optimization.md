# oh-my-god: Solo Developer Optimization

## Context

oh-my-god was initially designed with team use in mind (consistent output, shared standard, multi-platform). After brainstorming, the primary use case is **solo developer** with these pain points:

- B: AI claims done without real verification
- C: AI fixes symptoms not root causes  
- D: Must re-explain context every new session

## Changes

### 1. Default Engagement Mode → Express

**Current:** No default specified — agent decides
**New:** Default to Express (zero approval gates mid-session)

Only gate that remains: before BUILD starts (HARD GATE on design approval).
All other phase transitions happen automatically without asking.

**Why:** Solo developer doesn't need to approve their own decisions at every phase. The gates slow down solo work without adding value.

**Where:** `skills/oh-my-god/SKILL.md` — add to opening section

---

### 2. Receipt Format → Lightweight Checklist

**Current:** Full JSON receipt per phase (designed for orchestrator validation in team pipelines)

```json
{
  "phase": "BUILD",
  "task": "Task-3",
  "agent": "software-engineer",
  "artifacts": [...],
  "metrics": {...},
  "effort": {...},
  "verification": "..."
}
```

**New:** Markdown checklist appended to a single `receipts.md` file

```markdown
## 2026-04-13 14:32 | BUILD | Task-3
- [x] Tests written and watched fail first
- [x] All tests pass (npm test output: 6/6)
- [x] No scope creep
- [x] Committed
```

**Why:** JSON receipts add friction for solo use. The value is in the verification checklist, not the structured format. A running markdown log is easier to read across sessions.

**Where:** `skills/oh-my-god/SKILL.md` — Phase 4 BUILD receipt section

---

### 3. Session-Start Hook → Auto-load Prior Context

**Current:** No session-start hook. User must re-explain project context every session.

**New:** Hook that runs at session start and:
1. Reads `receipts.md` — shows last completed phase and open tasks
2. Reads `docs/specs/` — finds latest spec file and summarizes objective
3. Prints a brief context block so the agent knows where things left off

```
━━━ oh-my-god | Session Resume ━━━━━━━━━━━━━━━━━━━
  Last phase:   BUILD — Task 3 of 7 complete
  Open spec:    docs/specs/2026-04-13-auth-design.md
  Last receipt: 2026-04-13 14:32
  Status:       In progress — Task 4 next
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**Why:** Directly solves pain point D. Agent starts each session knowing exactly where things left off without the user having to explain.

**Where:** New file `hooks/session-start.sh` + register in `hooks/hooks.json`

---

### 4. stat.md — Skill Usage Tracking

**Current:** ไม่มีการเก็บข้อมูลว่าใช้ skill ไหนบ้าง

**New:** ไฟล์ `stat.md` ที่ update ทุกครั้งที่ใช้ skill

```markdown
# oh-my-god | Skill Usage Stats

Last updated: 2026-04-13 14:32

| Skill | Uses | Last used |
|-------|------|-----------|
| oh-my-god | 12 | 2026-04-13 |
| test-driven-development | 8 | 2026-04-13 |
| systematic-debugging | 5 | 2026-04-12 |
| spec-driven-development | 3 | 2026-04-11 |
| brainstorming | 2 | 2026-04-13 |
```

**Why:** รู้ว่าใช้ skill ไหนบ่อย — ช่วย identify ว่า workflow ไหน work ดีที่สุด และ skill ไหนไม่ได้ใช้เลย (อาจ remove ได้)

**Where:** สร้างไฟล์ `stat.md` ที่ root — session-start hook อ่านและแสดงใน context block ด้วย

**Format เพิ่มใน session resume:**
```
━━━ oh-my-god | Session Resume ━━━━━━━━━━━━━━━━━━━
  Last phase:   BUILD — Task 3 of 7 complete
  Top skills:   tdd (8x), debugging (5x), spec (3x)
  Last receipt: 2026-04-13 14:32
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Boundaries

**ALWAYS DO:**
- Keep Iron Laws unchanged — they solve the core pain points (B and C)
- Keep HARD GATE before BUILD — this is the one gate that matters even solo
- Keep all 46 skills — they're referenced by oh-my-god skill

**ASK FIRST:**
- Any changes to Iron Law wording
- Adding new gates

**NEVER DO:**
- Remove verification requirements
- Make receipts optional — lightweight yes, skippable no

---

## Success Criteria

- Starting a new session takes under 10 seconds to resume context (no manual re-explanation)
- No approval prompts between phases except the design gate
- Receipt format readable at a glance in under 5 seconds
