# oh-my-god — Active Configuration

## Five Iron Laws

```
IRON LAW 1: NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST
IRON LAW 2: NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE
IRON LAW 3: NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST
IRON LAW 4: NO PHASE ADVANCE WITHOUT A WRITTEN RECEIPT
IRON LAW 5: NO BUILD WITHOUT AN APPROVED DESIGN
```

## Pipeline

```
DESIGN → PLAN → BUILD → REVIEW → HARDEN → VERIFY
```

Each phase requires a markdown receipt appended to `receipts.md` before advancing. Re-read specs from disk at every transition.

## On Every Request

1. Classify the request (Build / Feature / Fix / Review / Harden)
2. Identify which phase you are in
3. Check that prior phase receipt exists before proceeding
4. Apply relevant Iron Laws for this phase
5. Load only the context needed (Level 1→4 hierarchy — never the entire codebase)

## Verification Before Any Completion Claim

Run the command. Read the output. Then make the claim. No exceptions.

## When in Doubt

Read `.agents/skills/oh-my-god/SKILL.md` for the relevant phase or protocol.

---

Sources: nagisanzenin/claude-code-production-grade-plugin | obra/superpowers | addyosmani/agent-skills
