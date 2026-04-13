---
name: master-protocol
description: >
  Unified AI Engineering Standard. Synthesized from Production-Grade Plugin (nagisanzenin),
  Superpowers (obra), and Agent Skills (addyosmani). Use when building, reviewing, debugging,
  or shipping any software. Combines pipeline gates with Iron Laws and context engineering.
---

# MASTER PROTOCOL v1.0
## The Unified AI Engineering Standard

Synthesized from three production-grade systems:
- **Production-Grade Plugin** (nagisanzenin) — Multi-agent orchestration, receipt gates, re-anchoring
- **Superpowers** (obra) — Iron Laws, TDD discipline, evidence-based verification
- **Agent Skills** (addyosmani) — Google engineering practices, context hierarchy, anti-rationalization

---

## FIVE IRON LAWS

These cannot be negotiated. Violating the letter violates the spirit.

```
IRON LAW 1: NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST
IRON LAW 2: NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE
IRON LAW 3: NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST
IRON LAW 4: NO PHASE TRANSITION WITHOUT A RECEIPT
IRON LAW 5: NO BUILD WITHOUT A SPEC
```

When you catch yourself rationalizing around any Iron Law — STOP. That thought is the red flag.

---

## GOOGLE ENGINEERING PRINCIPLES

Embedded throughout every phase:

- **Hyrum's Law** — All observable behaviors become dependencies. Change them carefully.
- **Beyoncé Rule** — If you liked it, you should have put a test on it.
- **Chesterton's Fence** — Never remove something until you understand why it exists.
- **Code as Liability** — Every line is debt. The best code is no code.
- **YAGNI** — You aren't gonna need it. Build what's asked, nothing more.

---

## THE 8-PHASE UNIFIED PIPELINE

```
IDEATE → SPECIFY → ARCHITECT → BUILD → REVIEW → HARDEN → SHIP → SUSTAIN
```

Each phase ends with a receipt. No receipt = phase not complete. Gates between phases
require human approval. Re-read specs from disk at every phase transition (Re-Anchoring).

---

## PHASE 1: IDEATE

*Superpowers brainstorming + Agent Skills idea-refine*

### Hard Gate

```
DO NOT write any code, scaffold any project, or take any implementation
action until a design is presented and the user has approved it.
This applies to EVERY request regardless of perceived simplicity.
```

### Checklist (complete in order)

- [ ] Explore project context — files, docs, recent commits
- [ ] Surface assumptions explicitly before asking questions
- [ ] If scope spans multiple independent subsystems, decompose first
- [ ] Ask clarifying questions — ONE AT A TIME, max 3 rounds
- [ ] Propose 2-3 approaches with trade-offs and your recommendation
- [ ] Present design in sections — get approval after each section
- [ ] Write design doc to `docs/specs/YYYY-MM-DD-<topic>-design.md`
- [ ] Self-review spec: placeholders? contradictions? ambiguity? scope?
- [ ] Ask user to review written spec before proceeding
- [ ] Transition: invoke writing-plans / SPECIFY phase

### Anti-Pattern: "This Is Too Simple To Need A Design"

Every project goes through this. A todo list, a single-function utility, a config change — all of them. Simple projects are where unexamined assumptions cause the most wasted work.

### Common Rationalizations

| Excuse | Counter |
|--------|---------|
| "I already understand what's needed" | Surface your assumptions. You're probably wrong about at least one. |
| "It's a small change, skip design" | Small changes with no design become large incidents. |
| "The user just wants me to start" | Present design first. Users want the right thing built, not the fast thing. |

### Receipt

```json
{
  "phase": "IDEATE",
  "spec_file": "docs/specs/YYYY-MM-DD-topic-design.md",
  "alternatives_considered": ["option-a", "option-b"],
  "selected_approach": "...",
  "rationale": "...",
  "human_approved": true
}
```

---

## PHASE 2: SPECIFY

*Agent Skills spec-driven-development + Production-Grade Requirements Gate*

**Entry condition:** IDEATE receipt exists. Re-read prior receipt from disk.

### Six Mandatory Spec Areas

Every spec must cover all six. No exceptions.

**1. Objective**
What is being built, who is the target user, and what are the measurable success criteria.
Transform vague → measurable:
- WRONG: "improve performance"
- RIGHT: "Reduce LCP to under 2.5s on 4G; FCP under 1.8s; P95 < 200ms"

**2. Commands**
Complete executable commands for build, test, lint, dev server. Someone new should run these without guessing.

**3. Project Structure**
Directory layout with description of each section's purpose.

**4. Code Style**
Actual code examples demonstrating preferred patterns. Not prose descriptions — working code.

**5. Testing Strategy**
Framework selection, test file locations, coverage targets, test pyramid allocation (80/15/5).

**6. Boundaries**

```
ALWAYS DO:   mandatory practices — non-negotiable
ASK FIRST:   decisions requiring human approval
NEVER DO:    prohibited actions
```

### Gate: SPECIFY → ARCHITECT

- [ ] All 6 spec areas complete
- [ ] Success criteria are measurable (numbers, not adjectives)
- [ ] Boundaries explicitly defined for all three tiers
- [ ] Spec committed to version control
- [ ] Human sign-off obtained

### Receipt

```json
{
  "phase": "SPECIFY",
  "spec_file": "path/to/spec.md",
  "success_criteria": ["LCP < 2.5s", "P95 < 200ms"],
  "boundaries": {
    "always_do": [],
    "ask_first": [],
    "never_do": []
  },
  "human_approved": true
}
```

---

## PHASE 3: ARCHITECT

*Production-Grade Solution Architect + Agent Skills documentation-and-adrs*

**Entry condition:** SPECIFY receipt exists. Re-read spec from disk (Re-Anchoring).

### Process

1. Derive tech stack from constraints — NOT from templates or personal preference
2. Write ADR for every significant architectural decision
3. Define API contracts before implementation begins
4. Map dependency directions — no circular dependencies allowed
5. Identify parallel vs. sequential work paths for BUILD phase

### ADR Format

```markdown
# ADR-NNN: [Decision Title]
Status: Proposed | Accepted | Deprecated
Date: YYYY-MM-DD

## Context
Why this decision point exists. What forces are at play.

## Decision
What we decided to do.

## Consequences
Trade-offs accepted. What becomes easier. What becomes harder.

## Alternatives Rejected
What we considered and why we said no.
```

### Gate: ARCHITECT → BUILD

- [ ] Tech stack justified by constraints (not preference)
- [ ] ADR written for every significant decision
- [ ] API contracts defined and documented
- [ ] No circular dependencies in dependency graph
- [ ] Human sign-off obtained

---

## PHASE 4: BUILD

*Superpowers TDD + Agent Skills incremental-implementation + Production-Grade agents*

**Entry condition:** ARCHITECT receipt exists. Re-read spec + ADRs from disk (Re-Anchoring).

### IRON LAW 1: TDD

```
NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST

Write code before the test? Delete it. Start over.
No exceptions:
- Don't keep it as "reference"
- Don't "adapt" it while writing tests
- Delete means delete
```

### RED-GREEN-REFACTOR Cycle

```
RED:      Write one failing test showing what should happen
VERIFY:   Run test. Confirm it fails for the right reason. MANDATORY — never skip.
GREEN:    Write the simplest code that makes the test pass
VERIFY:   Run test. Confirm it passes. All other tests still pass.
REFACTOR: Remove duplication, improve names. Keep tests green.
REPEAT:   Next failing test for next behavior.
```

**Verify RED is mandatory.** If the test passes immediately, you are testing existing behavior. Fix the test.

**Verify GREEN is mandatory.** If other tests break, fix them now — not later.

### Incremental Slices

- One vertical path per slice: DB → Service → API → UI
- Maximum 5 files per task
- Feature flags for incomplete work
- Each slice independently testable

### Context Engineering (per task)

Load the right context at the right time:

```
Level 1: Rules file (CLAUDE.md) — always loaded
Level 2: Relevant spec section — loaded per feature
Level 3: Files you will modify + one similar working example
Level 4: Error output from failing tests — loaded per iteration
```

Do NOT load the entire spec or entire codebase. Focused context outperforms large context.

### TDD Common Rationalizations — All Are Wrong

| Excuse | Reality |
|--------|---------|
| "Too simple to test" | Simple code breaks. Test takes 30 seconds. |
| "I'll write tests after" | Tests written after pass immediately. Passing immediately proves nothing. |
| "I already manually tested it" | Ad-hoc is not systematic. No record, can't re-run. |
| "Deleting X hours is wasteful" | Sunk cost fallacy. Keeping unverified code is technical debt. |
| "Need to explore first" | Fine. Throw away the exploration. Start TDD fresh. |
| "TDD will slow me down" | TDD is faster than debugging. Pragmatic = test-first. |

### TDD Red Flags — STOP and Start Over

- Code written before test
- Test passes immediately without implementation
- Can't explain why test failed
- "Tests added later"
- "Keep as reference"
- "This is different because..."

**ALL of these mean: Delete code. Start over.**

### Gate: BUILD → REVIEW

- [ ] Every new function has a test that existed and failed first
- [ ] All tests pass (command output attached, not claimed)
- [ ] No implementation without RED phase completed
- [ ] Feature flags for any incomplete work

---

## PHASE 5: REVIEW

*Agent Skills 5-axis review + Production-Grade adversarial review*

**Entry condition:** BUILD receipt exists.

**Adversarial stance:** Assume code is wrong until proven correct by tests and evidence.

### Five-Axis Review (mandatory for all changes)

**Axis 1: Correctness**
Edge cases handled? Race conditions? Off-by-one errors? Error paths tested?

**Axis 2: Readability**
Can a peer understand this independently in 6 months without reading internals?
Descriptive names? Logical organization? Dead code removed?

**Axis 3: Architecture**
Aligns with ADRs? Clean module boundaries? No duplication?
Dependency direction correct? Right abstraction level?

**Axis 4: Security**
Input validated at boundaries? Secrets out of code? Auth enforced?
Queries parameterized? Output encoded? Dependencies audited?

**Axis 5: Performance**
N+1 queries? Unbounded loops? Missing pagination?
Synchronous where async needed? Unnecessary re-renders?

### Severity Labels

- `CRITICAL` — Security vulnerability, data loss, broken functionality → blocks merge
- `REQUIRED` — Must fix before merge
- `OPTIONAL` — Worth considering
- `NIT` — Minor style preference

### Change Sizing

- Ideal: ~100 lines
- Acceptable: up to 300 lines for one logical change
- Must split: over 1000 lines → use stacking, file grouping, or vertical slicing

### Code Health Principle

Approve changes that improve overall code health, even if imperfect. Never block improvements because they differ from personal preference. Require cleanup before merge — deferred cleanup never happens.

### Gate: REVIEW → HARDEN

- [ ] All 5 axes evaluated with findings documented
- [ ] Zero CRITICAL findings remaining
- [ ] All REQUIRED findings resolved
- [ ] Change size within acceptable limits

---

## PHASE 6: HARDEN

*Agent Skills security-and-hardening + Production-Grade QA + Superpowers verification*

**Entry condition:** REVIEW receipt exists.

### Security Checklist (non-negotiable — verify with commands, not memory)

**Always Do:**
- [ ] All external input validated at system boundaries (user input, API responses, DB output)
- [ ] Database queries parameterized — zero string concatenation with user data
- [ ] Output encoded to prevent injection (framework auto-escaping enabled)
- [ ] HTTPS enforced for all external communication
- [ ] Passwords hashed: bcrypt/scrypt/argon2, minimum 12 rounds
- [ ] Security headers configured: CSP, HSTS, X-Frame-Options, X-Content-Type-Options
- [ ] Session cookies: httpOnly, secure, sameSite attributes set
- [ ] Dependency audit run — zero critical/high findings (`npm audit`, `cargo audit`, etc.)

**Never Do:**
- [ ] No secrets in version control (verify: `git log --all -S "password" --oneline`)
- [ ] No sensitive data in logs (passwords, tokens, card numbers, PII)
- [ ] No client-side-only validation as security boundary
- [ ] No dynamic code execution with user-controlled strings
- [ ] No auth tokens in localStorage or sessionStorage
- [ ] No stack traces exposed to end users

**Rate Limits:**
- General endpoints: 100 requests per 15 minutes
- Auth endpoints: 10 attempts per 15 minutes

### IRON LAW 2: Verification Before Completion

```
NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE

The Gate Function:
1. IDENTIFY: What command proves this claim?
2. RUN:      Execute the FULL command (fresh, this message)
3. READ:     Full output, check exit code, count failures
4. VERIFY:   Does output confirm the claim?
5. ONLY THEN: Make the claim

Skip any step = lying, not verifying
```

**Red Flags — STOP:**
- Using "should", "probably", "seems to"
- "Great!", "Perfect!", "Done!" before verification
- Trusting agent success reports without independent verification
- Partial check treated as full verification
- "Just this once"

**Verification Rationalizations — All Are Wrong:**

| Excuse | Reality |
|--------|---------|
| "Should work now" | RUN the verification |
| "I'm confident" | Confidence is not evidence |
| "Agent said success" | Verify independently |
| "Linter passed" | Linter is not the compiler |
| "Partial check is enough" | Partial proves nothing |

### Gate: HARDEN → SHIP

- [ ] Security checklist verified with actual command output attached
- [ ] Zero critical/high findings (audit output attached)
- [ ] Load testing completed with results
- [ ] Production Readiness Review passed

### Receipt

```json
{
  "phase": "HARDEN",
  "security_audit": { "critical": 0, "high": 0, "medium": 0 },
  "audit_command": "npm audit --json",
  "audit_output_lines": "...",
  "human_approved": true
}
```

---

## PHASE 7: SHIP

*Production-Grade DevOps/SRE + Agent Skills git-workflow + shipping-and-launch*

**Entry condition:** HARDEN receipt exists.

### Git Workflow

- Trunk-based development — no long-lived feature branches
- Atomic commits — one logical change per commit
- Imperative subject line: "Add email validation" not "Added email validation"
- Body explains WHY, not what (the diff shows the what)
- Reference ADRs in commit messages for architectural changes

### Staged Rollout

1. Deploy to staging → smoke test critical paths
2. 5% canary → monitor error rate + P95 latency for 30 minutes
3. 25% → monitor
4. 100% → full deploy

**Rollback Triggers (automatic):**
- Error rate exceeds baseline by more than 2 standard deviations
- P99 latency exceeds 2× baseline
- Any data integrity anomaly detected

### SLO Targets (define before shipping, not after)

```
Availability:  99.9% (43.8 min/month downtime budget)
P95 latency:   < [X]ms (set per service)
Error rate:    < 0.1%
```

### Gate: SHIP → SUSTAIN

- [ ] Staging smoke tests passed (output attached)
- [ ] Canary monitoring clean for 30 minutes minimum
- [ ] SLOs confirmed in monitoring dashboard
- [ ] Rollback procedure documented and tested

---

## PHASE 8: SUSTAIN

*Production-Grade documentation + Agent Skills documentation-and-adrs*

**Entry condition:** SHIP receipt exists.

### Mandatory Outputs

1. Update API reference documentation
2. Mark ADRs as `Accepted` status
3. Write runbook for new operational procedures
4. Extract reusable patterns as new skills
5. Update spec with post-ship learnings

### Compound Learning

Document what was surprising or non-obvious. This is the highest-value information — it represents the gap between what the team assumed and what was actually true. Future sessions need this.

---

## THE 8 UNIVERSAL PROTOCOLS

Always active. No agent, no phase may bypass these.

### Protocol 1: Receipt Protocol (Production-Grade)

Every phase transition requires a JSON receipt proving completion. Receipts must be the LAST action before marking a task complete. Orchestrator validates receipts — including checking that every file listed in `artifacts` actually exists on disk — before advancing.

```json
{
  "task": "T3",
  "agent": "software-engineer",
  "phase": "BUILD",
  "status": "complete",
  "artifacts": ["src/auth/login.ts", "tests/auth/login.test.ts"],
  "metrics": { "tests_written": 8, "tests_passing": 8, "files_changed": 2 },
  "effort": { "files_read": 12, "files_written": 2, "tool_calls": 34 },
  "verification": "ran npm test, 8/8 pass, watched RED-GREEN for each"
}
```

**Receipt anti-patterns:**
- Writing receipt before work is done
- Empty artifacts array when files were created
- `"verification": "done"` — describe what was actually verified
- Skipping for "small tasks" — every task gets a receipt

### Protocol 2: Re-Anchoring Protocol (Production-Grade)

At every phase transition, re-read spec and relevant ADRs from disk. Do not rely on context window memory of prior phase outputs. Context drift causes decisions that contradict the spec.

### Protocol 3: TDD Protocol (Superpowers)

RED first. Always. This is Iron Law 1. No code before a failing test.

### Protocol 4: Verification Protocol (Superpowers)

Evidence before claims. This is Iron Law 2. Run the command. Read the output. Then make the claim.

### Protocol 5: Systematic Debugging Protocol (Superpowers)

Iron Law 3: No fixes without root cause investigation first.

**Four phases — must complete each before proceeding:**

```
Phase 1: Root Cause — Read errors. Reproduce consistently. Check recent changes.
         Gather evidence at component boundaries before forming hypothesis.

Phase 2: Pattern Analysis — Find working examples. Compare. Identify differences.

Phase 3: Hypothesis — ONE hypothesis at a time. Make SMALLEST change to test it.
         Didn't work? Form NEW hypothesis. Don't stack fixes.

Phase 4: Implementation — Write failing test first. Fix root cause (not symptom).
         Verify fix works. If 3+ fixes failed: question the architecture.
```

**Red Flags — STOP and return to Phase 1:**
- "Quick fix for now, investigate later"
- "Just try changing X and see"
- "It's probably X, let me fix that"
- "One more fix attempt" (after 2+ failures)
- Proposing solutions before tracing data flow

### Protocol 6: Context Engineering Protocol (Agent Skills)

Load the right context at the right time:

```
Level 1 — Rules file (CLAUDE.md): Always loaded, project-wide
Level 2 — Spec section: Loaded per feature, not the full spec
Level 3 — Source files: Read before editing, find working example first
Level 4 — Error output: Specific errors only, not 500 lines of logs
Level 5 — Conversation: Compact/summarize when switching major tasks
```

**Context anti-patterns:**
- Loading entire codebase (floods context, agent loses focus)
- No rules file (agent invents conventions)
- Stale context from prior sessions (start fresh when switching features)
- Missing examples (agent invents a new style instead of following yours)

When context conflicts (spec says X, code has Y): surface it explicitly. Do NOT silently pick one.

### Protocol 7: Freshness Protocol (Production-Grade)

Verify volatile data before using it:
- Library versions → check current release (context7 or official docs)
- API contracts → verify against live documentation
- Dependencies → audit before release
- External behavior → test in staging, not assumed from docs

### Protocol 8: Boundary Safety Protocol (Production-Grade)

Validate all data at system boundaries:
- User input: validate schema before processing
- External API responses: validate before consuming
- Database output: never assume schema stability
- Inter-service messages: validate at consumer, not producer only

---

## THE AGENT ROSTER

12 specialized agents. Sole-authority domains do not negotiate.

| # | Agent | Sole Authority | Key Skill |
|---|-------|---------------|-----------|
| 0 | **Orchestrator** | Pipeline routing, receipt validation | Ensures no phase skipped |
| 1 | **Polymath** | Research, ideation, onboarding | Brainstorming + alternatives |
| 2 | **Product Manager** | Requirements, BRD, acceptance criteria | Only authority on requirements |
| 3 | **Solution Architect** | ADRs, tech stack, API contracts | Only authority on architecture |
| 4 | **Software Engineer** | Backend: services, repositories, handlers | TDD + incremental slices |
| 5 | **Frontend Engineer** | Design system, components, WCAG 2.1 AA | Accessibility-first UI |
| 6 | **QA Engineer** | Test pyramid (80/15/5), regression coverage | Beyoncé Rule enforcer |
| 7 | **Security Engineer** | STRIDE, OWASP, PII, supply chain | Only authority on security |
| 8 | **Code Reviewer** | 5-axis review, adversarial quality | Assumes code is wrong |
| 9 | **DevOps/SRE** | Docker, CI/CD, IaC, SLOs, runbooks | Only authority on infrastructure |
| 10 | **Context Engineer** | Information architecture, context loading | Optimal context per task |
| 11 | **Debug Specialist** | Root cause analysis | 4-phase systematic debugging |

**Conflict resolution:** Sole-authority domain wins. Security Engineer's security decision is final. Architect's architecture decision is final. No cross-domain negotiation.

---

## REQUEST CLASSIFICATION

Before executing, classify the request. This determines which agents run.

| Mode | Trigger Signals | Agents |
|------|----------------|--------|
| **Full Build** | greenfield, "from scratch", "build a SaaS" | All 12, full pipeline |
| **Feature** | "add [feature]", "implement [feature]", "new endpoint" | PM + Architect + Engineer + QA |
| **Harden** | "review", "audit", "secure", "before launch" | Security + QA + Code Reviewer |
| **Ship** | "deploy", "CI/CD", "docker", "infrastructure" | DevOps + SRE |
| **Test** | "write tests", "test coverage", "add tests" | QA Engineer |
| **Review** | "code review", "review my code" | Code Reviewer |
| **Debug** | error, failure, unexpected behavior | Debug Specialist |
| **Architect** | "design", "tech stack", "API design" | Solution Architect |
| **Document** | "write docs", "API docs", "README" | Technical Writer |

Single-agent modes (Test, Review, Debug, Architect, Document): skip plan presentation, invoke immediately.
Multi-agent modes: present plan for confirmation before executing.

---

## 4 ENGAGEMENT MODES

User selects at session start. Three pipeline gates always require human approval regardless of mode.

| Mode | Questions | Best For |
|------|-----------|----------|
| **Express** | Zero — auto-resolve all | Trusted expert execution |
| **Standard** | 1-2 per phase — subjective/irreversible only | Normal development |
| **Thorough** | All major decisions | Complex or high-risk features |
| **Meticulous** | Every decision point | Critical systems |

---

## 7 LIFECYCLE COMMANDS

| Command | Phase | Action |
|---------|-------|--------|
| `/spec` | SPECIFY | Create or update the six-area specification |
| `/plan` | ARCHITECT | Generate implementation plan with ADRs |
| `/build` | BUILD | Execute TDD cycle for a task |
| `/test` | BUILD/HARDEN | Run full test suite with evidence output |
| `/review` | REVIEW | 5-axis adversarial review |
| `/simplify` | Any | Reduce complexity, apply Chesterton's Fence |
| `/ship` | SHIP | Staged deployment with rollback plan |

---

## UNIVERSAL ANTI-RATIONALIZATION TABLE

These excuses appear across all phases. Counter-evidence is required to override.

| Phase | Excuse | Counter |
|-------|--------|---------|
| IDEATE | "Skip design, just start" | Unexamined assumptions are where wasted work lives |
| SPECIFY | "Success criteria can be vague" | Vague criteria ship the wrong thing |
| BUILD | "I'll add tests after" | Tests after pass immediately and prove nothing |
| BUILD | "This is too simple to test" | Simple code breaks. Test takes 30 seconds. |
| REVIEW | "The review is a formality" | Adversarial review found the bug the author missed |
| HARDEN | "Security checklist is overkill" | Security debt is invisible until breach |
| SHIP | "Skip the canary, it's a small change" | Small changes cause production incidents |
| ANY | "Just this once" | No exceptions |
| ANY | "I'm confident it works" | Confidence is not evidence. Run the command. |

---

## PRE-COMPLETION VERIFICATION GATE

Before claiming ANY work complete, verify all of the following:

- [ ] Ran the actual tests (not "should pass") — output attached
- [ ] Read the actual output — did not predict it
- [ ] The specific behavior claimed actually works when tested
- [ ] Edge cases I said I would check were actually checked
- [ ] Security checklist verified with commands — not acknowledged from memory
- [ ] Receipt generated with actual evidence — no placeholder fields

```
EVIDENCE BEFORE ASSERTIONS — ALWAYS
```

---

*Master Protocol v1.0 | Synthesized 2026-04-13*
*Sources: nagisanzenin/claude-code-production-grade-plugin | obra/superpowers | addyosmani/agent-skills*
