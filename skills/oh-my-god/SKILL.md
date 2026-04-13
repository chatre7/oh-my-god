---
name: oh-my-god
description: >
  Full-cycle engineering skill. Combines the best of Production-Grade Plugin (receipt gates,
  subagent orchestration), Superpowers (Iron Laws, subagent-driven development, writing plans),
  and Agent Skills (vertical slicing, incremental implementation, context engineering).
  Use for any build, feature, debug, or review task that requires production-grade discipline.
  Triggers on: "build", "implement", "add feature", "fix", "review", "oh-my-god".
platforms:
  claude-code: "Native — full subagent support"
  gemini-cli: "Supported — see references/gemini-tools.md (no subagents: falls back to sequential)"
  codex: "Supported — see references/codex-tools.md (no subagents: falls back to sequential)"
  opencode: "Supported — see references/opencode-tools.md (subagents via @mention)"
---

# oh-my-god

The unified engineering skill. Combines the sharpest tools from three systems into one workflow.

## Platform Support

| Platform | Activation | Subagents | Notes |
|----------|-----------|-----------|-------|
| **Claude Code** | `Skill` tool or auto-trigger | Full support | Native experience |
| **Gemini CLI** | `activate_skill` or `@skills/oh-my-god/SKILL.md` | Not supported — sequential fallback | See `references/gemini-tools.md` |
| **Codex** | Auto via AGENTS.md → CLAUDE.md | Not supported — sequential fallback | See `references/codex-tools.md` |
| **OpenCode** | `skill` tool or auto | `@mention` syntax | See `references/opencode-tools.md` |

When subagents are not supported: execute each BUILD task sequentially in the same session. Run 2-stage review as inline evaluation steps after each task.

**Sources:**
- Production-Grade Plugin — request classification, receipt gates, subagent orchestration
- Superpowers — Iron Laws, writing-plans (no placeholders), subagent-driven-development (2-stage review)
- Agent Skills — vertical slicing, incremental implementation, scope discipline, context engineering

---

## DEFAULT MODE: EXPRESS

Solo developer mode — active by default.

- Zero approval prompts between phases
- Only one gate remains: HARD GATE before BUILD (design must be approved)
- All other phase transitions happen automatically

To switch modes, say: "use Thorough mode" or "use Meticulous mode"

---

## FIVE IRON LAWS

Violating the letter violates the spirit. No exceptions.

```
IRON LAW 1: NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST
IRON LAW 2: NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE
IRON LAW 3: NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST
IRON LAW 4: NO PHASE ADVANCE WITHOUT A WRITTEN RECEIPT
IRON LAW 5: NO BUILD WITHOUT AN APPROVED DESIGN
```

When you catch yourself rationalizing around any Iron Law — that thought is the red flag.

---

## STEP 0: CLASSIFY THE REQUEST

Before anything, identify the mode. This determines which phases run.

| Mode | Trigger Signals | Phases |
|------|----------------|--------|
| **Build** | "build", "create", "new feature", greenfield | ALL phases |
| **Feature** | "add [X]", "implement [X]", "new endpoint" | DESIGN → PLAN → BUILD → VERIFY |
| **Fix** | error, bug, test failure, unexpected behavior | DEBUG → BUILD → VERIFY |
| **Review** | "review my code", "code review" | REVIEW only |
| **Harden** | "secure", "audit", "before launch" | REVIEW + HARDEN |

Announce the mode at the start:
```
━━━ oh-my-god | [Mode] ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Mode: [Build / Feature / Fix / Review / Harden]
  Phases: [list]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## PHASE 1: DESIGN

*From: Superpowers brainstorming + Agent Skills spec-driven-development*

Skip for Fix and Review modes. Required for Build and Feature modes.

### HARD GATE

```
DO NOT write any code, scaffold any project, or invoke any implementation
action until the design is presented and the human has approved it.

This applies to EVERY request regardless of perceived simplicity.
"Simple" projects are where unexamined assumptions cause the most wasted work.
```

### Process

**1. Explore context first**
Read existing files, docs, recent commits. Understand before proposing.

**2. Surface assumptions**
Before asking questions, state what you're assuming. Ask the human to correct you.

**3. Ask ONE clarifying question at a time** (max 3 rounds)
Prefer multiple-choice questions. Focus on: purpose, constraints, success criteria.

**4. Check scope**
If the request spans multiple independent subsystems, decompose first.
Each subsystem gets its own design → plan → build cycle.

**5. Propose 2-3 approaches** with trade-offs. Lead with your recommendation and why.

**6. Present design in sections** — architecture, data flow, testing, error handling.
Get human approval after each section. Go back if something doesn't fit.

**7. Write the six spec areas** (save to `docs/specs/YYYY-MM-DD-<topic>-design.md`):

```
1. Objective      — what's built, who uses it, measurable success criteria
2. Commands       — exact executable commands for build, test, lint, dev
3. Structure      — directory layout with descriptions
4. Code Style     — working code examples, not prose descriptions
5. Testing        — framework, file locations, pyramid allocation (80/15/5)
6. Boundaries     — ALWAYS DO / ASK FIRST / NEVER DO
```

**Transform vague → measurable:**
- WRONG: "make it fast"
- RIGHT: "P95 response < 200ms, LCP < 2.5s on 4G"

**8. Self-review the spec**
- Placeholder scan: any "TBD", "TODO", incomplete sections? Fix them.
- Internal consistency: do sections contradict each other?
- Scope: focused enough for one plan, or needs decomposition?
- Ambiguity: could any requirement be interpreted two ways? Pick one.

**9. Human reviews spec**
"Spec written and saved to `<path>`. Review it and tell me if you want changes before I write the plan."

Wait. Do not proceed until approved.

### Design Gate Receipt

```json
{
  "phase": "DESIGN",
  "spec_file": "docs/specs/YYYY-MM-DD-topic-design.md",
  "success_criteria": ["measurable criterion 1", "measurable criterion 2"],
  "alternatives_considered": ["option-a", "option-b"],
  "selected": "option-a",
  "human_approved": true
}
```

---

## PHASE 2: PLAN

*From: Superpowers writing-plans + Agent Skills planning-and-task-breakdown*

Skip for Fix and Review modes. Announce: "I'm using the writing-plans process to create the implementation plan."

### Rules

**No placeholders — ever.** These are plan failures:
- "TBD", "TODO", "implement later"
- "Add appropriate error handling" (without showing the code)
- "Write tests for the above" (without actual test code)
- "Similar to Task N" (repeat the code — engineer may read out of order)
- Steps that describe what to do without showing how

**Every task must have:**
- Exact file paths (create / modify / test)
- Complete code in every step that involves code
- Exact commands with expected output
- Explicit acceptance criteria (testable, not vague)
- Dependency on which prior tasks

### Dependency Graph First

Map what depends on what before writing tasks:
```
Database schema
    │
    ├── Types / Models
    │       │
    │       ├── API endpoints
    │       │       └── Frontend client
    │       └── Validation
    └── Migrations / Seed data
```
Implementation order follows the graph bottom-up.

### Vertical Slicing (required)

Build one complete path through the stack per task — not all DB, then all API, then all UI.

**BAD (horizontal):**
- Task 1: All database schema
- Task 2: All API endpoints
- Task 3: All UI components

**GOOD (vertical):**
- Task 1: User can register (schema + API endpoint + form)
- Task 2: User can log in (auth + token + UI)
- Task 3: User can create a task (task schema + API + form)

Each vertical task delivers working, testable functionality.

### Task Sizing

| Size | Files | Action |
|------|-------|--------|
| XS | 1 | Single function or config |
| S | 1-2 | One endpoint or component |
| M | 3-5 | One feature slice (preferred) |
| L | 5-8 | Multi-component feature |
| XL | 8+ | **Too large — break it down** |

If a task is XL, break it. An agent performs best on S and M tasks.

### Task Template

```markdown
### Task N: [Short descriptive title]

**Description:** One paragraph explaining what this accomplishes.

**Files:**
- Create: `exact/path/to/new-file.ts`
- Modify: `exact/path/to/existing.ts`
- Test: `exact/path/to/file.test.ts`

**Dependencies:** Task N-1, Task N-2 (or "None")

- [ ] Step 1: Write the failing test
  [show actual test code]

- [ ] Step 2: Run test to confirm it fails
  Run: `npm test path/to/file.test.ts`
  Expected: FAIL — "[specific error message]"

- [ ] Step 3: Write minimal implementation
  [show actual implementation code]

- [ ] Step 4: Run test to confirm it passes
  Run: `npm test path/to/file.test.ts`
  Expected: PASS

- [ ] Step 5: Commit
  `git add [files] && git commit -m "feat: [description]"`

**Acceptance criteria:**
- [ ] [Specific, testable condition]
- [ ] [Specific, testable condition]
```

### Checkpoints (every 2-3 tasks)

```markdown
## Checkpoint: After Tasks N-M
- [ ] All tests pass: `npm test`
- [ ] Build succeeds: `npm run build`
- [ ] Core flow works end-to-end
- [ ] Human review before proceeding
```

### Plan Self-Review

After writing the full plan:
1. **Spec coverage** — skim each requirement. Can you point to a task that implements it? List gaps.
2. **Placeholder scan** — search for red-flag patterns. Fix all of them.
3. **Type consistency** — do method names in Task 7 match what Task 2 defined?

Fix inline. No re-review needed — just fix and move on.

### Save and Offer Execution Choice

Save to `docs/plans/YYYY-MM-DD-<feature>.md`

```
Plan saved to docs/plans/<filename>.md. Two execution options:

1. Subagent-Driven (recommended) — fresh subagent per task, 2-stage review between tasks
2. Inline — execute tasks in this session with checkpoints

Which approach?
```

### Plan Gate Receipt

```json
{
  "phase": "PLAN",
  "plan_file": "docs/plans/YYYY-MM-DD-feature.md",
  "task_count": 7,
  "checkpoints": 2,
  "execution_mode": "subagent-driven",
  "human_approved": true
}
```

---

## PHASE 3: BUILD

*From: Superpowers TDD + subagent-driven-development + Agent Skills incremental-implementation*

### IRON LAW 1: TDD

```
NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST

Write code before the test? Delete it. Start over.
No exceptions. No "I'll add tests after." Delete means delete.
```

### Execution: Subagent-Driven (recommended)

Fresh subagent per task + two-stage review after each task.

**Why fresh subagents:**
- Isolated context — no confusion from prior tasks
- You control exactly what information they receive
- Review catches what the implementer missed
- Preserves your coordination context

**Per-task loop:**

```
1. Extract task text + context from plan (read plan ONCE, upfront)
2. Dispatch implementer subagent with:
   - Full task text (complete — not a reference to read it themselves)
   - One working example of the pattern to follow
   - Relevant spec section only (not the full spec)
   - Exact test commands
3. Handle implementer status:
   - DONE             → proceed to spec review
   - DONE_WITH_CONCERNS → read concerns before reviewing
   - NEEDS_CONTEXT    → provide missing context, re-dispatch
   - BLOCKED          → assess: more context? bigger model? break task? escalate?
4. Dispatch SPEC COMPLIANCE reviewer:
   - Confirms code matches spec — nothing missing, nothing extra
   - If issues: implementer fixes → spec reviewer re-reviews
   - Only when spec review is PASS → proceed
5. Dispatch CODE QUALITY reviewer:
   - 5-axis: Correctness, Readability, Architecture, Security, Performance
   - CRITICAL findings block — implementer fixes → re-review
   - REQUIRED findings: must resolve
   - Only when code review is PASS → mark task complete
6. Write task receipt. Mark complete. Move to next task.
```

**Never skip either review stage.** Spec review before code quality. Always.

**Never dispatch multiple implementers in parallel.** They conflict.

### Context Engineering (per task)

Load only what the task needs:

```
Level 1 — Rules file (CLAUDE.md / project spec): always loaded
Level 2 — Relevant spec section only (not the full spec)
Level 3 — Files to modify + one working example of the pattern
Level 4 — Error output from failing tests (specific, not full log)
```

Context flooding is as bad as context starvation. More files does not mean better output.

Aim for under 2,000 lines of focused context per task.

### Incremental Slices — Scope Discipline

Each increment changes ONE logical thing. Do NOT:
- "Clean up" code adjacent to your change
- Refactor files you're only reading
- Add features not in the spec because they "seem useful"
- Modernize syntax in unrelated files

If you notice something worth improving outside scope:
```
NOTICED BUT NOT TOUCHING:
- src/utils/format.ts has an unused import (unrelated to this task)
→ Want me to create a task for this?
```

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

---

## PHASE 4: REVIEW

*From: Agent Skills 5-axis review + Production-Grade adversarial stance*

**Adversarial stance:** Assume code is wrong until proven correct by tests and evidence.

### Five-Axis Review

**Correctness**
Edge cases handled? Race conditions? Off-by-one errors? Error paths tested and asserted?

**Readability**
Can a peer understand this in 6 months without reading internals? Descriptive names? Dead code removed? "And" in a function name means it does two things.

**Architecture**
Aligns with ADRs and spec? Clean module boundaries? No duplication? Dependency direction correct? Abstraction earns its complexity?

**Security**
Input validated at boundaries? Auth enforced on every protected endpoint? Queries parameterized? Secrets out of code? Output encoded?

**Performance**
N+1 queries? Unbounded loops? Missing pagination? Blocking calls that should be async?

### Severity Labels

- `CRITICAL` — Security vulnerability, data loss, broken functionality → blocks merge, fix now
- `REQUIRED` — Must fix before merge
- `OPTIONAL` — Worth considering
- `NIT` — Minor style preference

### Change Sizing

- Ideal: ~100 lines
- Acceptable: up to 300 lines for one logical change
- Must split at 1000+ lines

**Code health principle:** Approve changes that improve overall code health even if imperfect. Never block improvements because they differ from personal preference. Require cleanup before merge — deferred cleanup never happens.

---

## PHASE 5: HARDEN

*From: Agent Skills security-and-hardening + Production-Grade QA*

Verify with actual commands. Not from memory. Not claimed — proven.

### Security Checklist

**Always Do (verify with commands):**
- [ ] External input validated at system boundaries
- [ ] DB queries parameterized — no string concatenation with user data
- [ ] Output encoded (framework auto-escaping active)
- [ ] HTTPS enforced for external communication
- [ ] Passwords hashed: bcrypt/scrypt/argon2, minimum 12 rounds
- [ ] Security headers: CSP, HSTS, X-Frame-Options, X-Content-Type-Options
- [ ] Session cookies: httpOnly, secure, sameSite set
- [ ] Dependency audit: `npm audit` or `cargo audit` — zero critical/high

**Never Do (verify: `git log --all`):**
- [ ] No secrets in version control
- [ ] No sensitive data in logs
- [ ] No client-side-only validation as security boundary
- [ ] No dynamic code execution with user-controlled strings
- [ ] No auth tokens in localStorage/sessionStorage
- [ ] No stack traces exposed to users

**Rate Limits:**
- General endpoints: 100 req / 15 min
- Auth endpoints: 10 attempts / 15 min

---

## PHASE 6: VERIFY

*From: Superpowers verification-before-completion — Iron Law 2*

```
NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE
```

### The Gate Function

Run this before claiming anything is done:

```
1. IDENTIFY — what command proves this claim?
2. RUN      — execute the full command NOW, in this message
3. READ     — full output, exit code, failure count
4. VERIFY   — does output confirm the claim?
            → NO: state actual status with evidence
            → YES: state claim WITH evidence attached
5. ONLY THEN — make the claim
```

Skip any step = lying, not verifying.

### Completion Evidence Required

| Claim | Required Evidence |
|-------|-----------------|
| Tests pass | Command output showing 0 failures |
| Build succeeds | Build command exit 0 |
| Bug fixed | Test that reproduces the bug now passes; watched RED then GREEN |
| Linter clean | Linter output: 0 errors |
| Security clean | Audit output: 0 critical/high |
| Agent completed | VCS diff showing actual changes |
| Requirements met | Line-by-line checklist against spec |

### Red Flags — STOP

- Using "should", "probably", "seems to"
- "Great!", "Perfect!", "Done!" before running a command
- Trusting an agent's success report without independent verification
- "Partial check is enough"
- "Just this once"
- ANY wording implying success before running verification

### Verification Rationalizations — All Are Wrong

| Excuse | Reality |
|--------|---------|
| "Should work now" | RUN the verification |
| "I'm confident" | Confidence is not evidence |
| "Agent said success" | Verify independently |
| "Linter passed" | Linter is not the compiler |
| "Partial check is enough" | Partial proves nothing |
| "Different words, rule doesn't apply" | Spirit over letter |

---

## PHASE D: DEBUG (when Fix mode)

*From: Superpowers systematic-debugging — Iron Law 3*

```
NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST

If you haven't completed Phase 1, you cannot propose fixes.
```

### Four Phases (complete each before the next)

**Phase 1 — Root Cause**
1. Read error messages completely (stack trace, line numbers, error codes)
2. Reproduce consistently — if you can't reproduce it, you can't fix it
3. Check recent changes (git diff, recent commits, new dependencies)
4. In multi-component systems: add diagnostic instrumentation at each boundary FIRST, run once to see WHERE it breaks, THEN investigate

**Phase 2 — Pattern Analysis**
1. Find working examples in the same codebase
2. Compare working vs. broken — list every difference, however small
3. Read reference implementation COMPLETELY before applying pattern

**Phase 3 — Hypothesis**
1. State ONE hypothesis: "I think X is the root cause because Y"
2. Make the SMALLEST possible change to test it
3. Did it work? Yes → Phase 4. No → form NEW hypothesis. Do NOT stack fixes.

**Phase 4 — Implementation**
1. Write failing test that reproduces the bug (Iron Law 1 applies here too)
2. Fix the root cause — not the symptom
3. Verify: test passes, no other tests broken
4. If 3+ fixes failed: STOP. Question the architecture. Discuss with human.

### Debug Red Flags — STOP, Return to Phase 1

- "Quick fix for now, investigate later"
- "Just try changing X"
- "I think I know what it is, let me fix it"
- Proposing solutions before tracing data flow
- "One more fix attempt" after 2+ failures
- Each fix reveals a new problem in a different place

---

## COMMON RATIONALIZATIONS — ALL PHASES

| Phase | Excuse | Counter |
|-------|--------|---------|
| DESIGN | "Skip design, just start" | Unexamined assumptions are where wasted work lives |
| DESIGN | "It's a small change" | Small changes with no design become incidents |
| PLAN | "Tasks are obvious, skip writing" | Written tasks surface hidden dependencies |
| PLAN | "Planning is overhead" | Planning IS the task. Coding without a plan is just typing. |
| BUILD | "I'll add tests after" | Tests after pass immediately and prove nothing |
| BUILD | "Delete X hours of work? Wasteful" | Sunk cost. Keeping unverified code is technical debt. |
| BUILD | "This refactor is small, I'll include it" | Refactors mixed with features make both harder to review |
| REVIEW | "The review is a formality" | Adversarial review found the bug the author missed |
| HARDEN | "Security checklist is overkill" | Security debt is invisible until breach |
| VERIFY | "I'm confident it works" | Confidence is not evidence |
| DEBUG | "I think I know the bug" | Thinking doesn't count. Reproduce first. |
| ANY | "Just this once" | No exceptions |

---

## RED FLAGS ACROSS ALL PHASES

**STOP immediately when you see:**

BUILD:
- Code written before a failing test
- Test passes immediately without implementation
- "I'll add tests after"
- "Keep as reference" (for deleted code)
- Scope creep: "while I'm here..."

REVIEW:
- Approving CRITICAL findings
- Skipping any of the 5 axes
- Change over 1000 lines without splitting

HARDEN:
- Claiming security clean without running audit command
- "Client-side validation is sufficient"

VERIFY:
- "Should", "probably", "seems to" in completion claim
- Satisfaction expressed before running verification command

DEBUG:
- Proposing fix before reproducing the bug
- "One more fix attempt" after 2+ failures

---

## PRE-COMPLETION GATE

Before claiming ANY work complete, check every box:

- [ ] Tests run (not "should pass") — output attached
- [ ] Read the actual output — did not predict it
- [ ] Specific behavior claimed actually works when tested right now
- [ ] Edge cases actually checked — not just acknowledged
- [ ] Security checklist verified with commands — not from memory
- [ ] Receipt written with actual artifact paths and real metrics
- [ ] Every artifact listed in receipt actually exists on disk

```
EVIDENCE BEFORE ASSERTIONS — ALWAYS
```

---

## FINAL RECEIPT (on skill completion)

Append to `receipts.md`:

```markdown
## [YYYY-MM-DD HH:MM] | COMPLETE | [Mode]
- [x] All phases completed
- [x] Tests passing: [N/N]
- [x] Security checklist verified
- [x] Spec criteria met line-by-line
```

---

*oh-my-god v1.0 — Synthesized from nagisanzenin/claude-code-production-grade-plugin + obra/superpowers + addyosmani/agent-skills*
