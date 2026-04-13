# Master Protocol — Active Configuration

This project uses the Master Protocol v1.0.
Full reference: `MASTER_PROTOCOL.md`

## Five Iron Laws

```
IRON LAW 1: NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST
IRON LAW 2: NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE
IRON LAW 3: NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST
IRON LAW 4: NO PHASE TRANSITION WITHOUT A RECEIPT
IRON LAW 5: NO BUILD WITHOUT A SPEC
```

## Pipeline

```
IDEATE → SPECIFY → ARCHITECT → BUILD → REVIEW → HARDEN → SHIP → SUSTAIN
```

Each phase requires a JSON receipt before advancing. Re-read specs from disk at every transition.

## On Every Request

1. Classify the request (Full Build / Feature / Harden / Ship / Test / Review / Debug / Architect / Document)
2. Identify which phase you are in
3. Check that prior phase receipt exists before proceeding
4. Apply relevant Iron Laws for this phase
5. Load only the context needed (Level 1→4 hierarchy — never the entire codebase)

## Verification Before Any Completion Claim

Run the command. Read the output. Then make the claim. No exceptions.

## When in Doubt

Read `MASTER_PROTOCOL.md` for the relevant phase or protocol.

---

Sources: nagisanzenin/claude-code-production-grade-plugin | obra/superpowers | addyosmani/agent-skills
