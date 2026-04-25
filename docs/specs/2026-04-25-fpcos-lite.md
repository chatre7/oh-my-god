# oh-my-god: FPCOS-Lite Cognitive Layer

## Context

oh-my-god has strong execution discipline (Iron Laws, phase gates, receipts). The 2026-04-13 solo developer optimization is in flight and addresses speed/resume pain.

What is still missing: **cognitive discipline before execution**. Iron Law 3 says "no fix without root cause" but provides no template for *how* to find it. Iron Law 2 says "no completion without fresh evidence" but the receipt does not capture *how confident* the agent is or *what is still unknown*.

The full FPCOS spec proposes 6 layers (L0-L5), 3 new reference docs, and ~340 new lines. That is over-engineered for a solo workflow and would create ceremony fatigue.

This spec extracts the **3 highest-value pieces** of FPCOS that fit the existing structure with minimal disruption. Defer the rest until receipts show the lite version is working.

**Pain points addressed:**
- Agent fixes symptoms because there is no enforced template for root cause analysis
- Receipts say "Completed" with no signal of how shaky the result is
- DESIGN phase mixes facts and assumptions silently, leading to hallucinated requirements

**Depends on:** 2026-04-13-solo-developer-optimization (receipt format must exist before adding fields). Do not BUILD this until that spec's receipt work lands.

---

## Changes

### 1. Receipt Schema → Add Confidence + Remaining Unknowns

**Current:** Lightweight markdown checklist per phase

```markdown
## 2026-04-13 14:32 | BUILD | Task-3
- [x] Tests written and watched fail first
- [x] All tests pass (npm test output: 6/6)
- [x] No scope creep
- [x] Committed
```

**New:** Same checklist plus two required lines at the end

```markdown
## 2026-04-25 14:32 | BUILD | Task-3
- [x] Tests written and watched fail first
- [x] All tests pass (npm test output: 6/6)
- [x] No scope creep
- [x] Committed
- Confidence: 85% — full suite green, manual smoke on happy path only
- Unknowns: edge case behavior on concurrent requests not exercised
```

**Rules:**
- Confidence is a percentage with a one-line reason. 100% is only allowed when all listed unknowns are resolved.
- Unknowns lists what was NOT verified. "None" is allowed but must be deliberate, not default.
- Both fields are required for VERIFY receipts. Optional for intermediate phase receipts.

**Why:** Forces the agent to admit uncertainty instead of binary done/not-done. A future session reading the receipt can see what is still risky without re-running everything.

**Where:** `.agents/skills/oh-my-god/SKILL.md` — receipt format section in Phase 6 VERIFY.

---

### 2. /debug → Add L2 System Lens Template

**Current:** `.claude/commands/debug.md` runs DEBUG → BUILD → VERIFY but provides no structured template for the DEBUG phase. Root cause analysis depends entirely on the agent remembering to do it well.

**New:** DEBUG phase output must include this template before any fix is proposed:

```markdown
### System Lens
Symptom:
Reproduction:
Observed vs Expected:
Data Flow:
  1. Input →
  2. Processing →
  3. Output →
Variables / State:
  - <name>: source → transformation → failure point
Dependencies touched:
Root Cause Hypothesis:
Evidence supporting hypothesis:
Ruled out:
```

**Rules:**
- No fix proposal until template is filled.
- If reproduction is impossible, state why and lower receipt confidence accordingly.
- "Ruled out" must list at least one alternative hypothesis that was checked, not assumed.

**Why:** Iron Law 3 is the law most often violated through optimism. A required template makes skipping it visible. This is the single highest-leverage FPCOS layer for a solo dev — debugging is where wrong root causes cost the most time.

**Where:** `.claude/commands/debug.md` — add template block to DEBUG phase instructions.

---

### 3. DESIGN Phase → Add L0 Reality Anchor

**Current:** DESIGN phase in SKILL.md jumps from problem statement to design options. Facts and assumptions are mixed.

**New:** DESIGN output must start with a 3-bucket separation:

```markdown
### Reality
Knowns (with evidence):
  - <fact> — <file:line | command output | user message>
Inferred (assumptions, may be wrong):
  - <assumption> — <why we are inferring this>
Unknowns (unresolved):
  - <missing info> — <does it block design? yes/no>
```

**Rules:**
- A bullet under Knowns without an evidence reference is invalid.
- Unknowns marked "blocks design: yes" must be resolved (ask user, read file, run command) before proposing options.
- Unknowns marked "blocks design: no" carry forward to the receipt's Unknowns section.

**Why:** Most hallucinated requirements come from the agent silently promoting an inference into a fact. Forcing the 3-bucket split makes silent promotion impossible.

**Where:** `.agents/skills/oh-my-god/SKILL.md` — Phase 1 DESIGN section, before "Design Options".

---

## What This Spec Deliberately Does NOT Add

To keep ceremony low, the following parts of the full FPCOS spec are **deferred**:

- **L1 Axiom Gate** (challenge whether requirement is necessary) — solo dev already filters this
- **L3 Compound Mind** (5-domain review) — `/review` already does 5-axis review; redundant
- **L4 Shadow Gate** (adversarial self-critique before BUILD) — same model critiquing itself has known low yield; revisit only if subagent orchestration is reliable
- **3 new reference files** (fpcos.md, gate-rules.md, receipt-schema.md) — fold guidance directly into SKILL.md and command files
- **New validation hook** for receipt schema — rely on agent compliance first; add hook only if compliance is poor

Re-evaluate after 4 weeks of receipts. If Confidence and Unknowns reliably catch real risk, expand. If they become ritual, simplify further.

---

## Boundaries

**ALWAYS DO:**
- Keep all 5 Iron Laws unchanged — this spec strengthens Law 2 and Law 3 only
- Keep Express mode default from 2026-04-13 spec — these additions must not re-introduce mid-session gates
- Keep receipt format human-readable

**ASK FIRST:**
- Adding Confidence/Unknowns to phases other than VERIFY
- Making the System Lens template apply outside `/debug`
- Any change to Iron Law wording

**NEVER DO:**
- Add the deferred FPCOS layers without a follow-up spec
- Add a hook that blocks commits on receipt format — this is documentation discipline, not CI
- Make Confidence default to 100% when unset — must be explicitly stated

---

## Success Criteria

- Every VERIFY receipt written after this lands has Confidence and Unknowns lines
- At least one DEBUG session within the next 4 weeks finds a root cause via the System Lens template that would have been missed otherwise (recorded in receipt)
- DESIGN phase Reality block surfaces at least one Unknown per non-trivial feature that would have been silently inferred before
- Total added lines across SKILL.md and debug.md is under 80
- No new reference files, no new hooks
