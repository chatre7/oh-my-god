# oh-my-god

> Production-grade AI engineering discipline — synthesized from three battle-tested systems into one unified skill.

```
IRON LAW 1: NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST
IRON LAW 2: NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE
IRON LAW 3: NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST
IRON LAW 4: NO PHASE ADVANCE WITHOUT A WRITTEN RECEIPT
IRON LAW 5: NO BUILD WITHOUT AN APPROVED DESIGN
```

---

## What it is

`oh-my-god` is a Claude Code skill that enforces engineering discipline across every request. It combines the sharpest ideas from three systems:

| | Source | What it brings |
|-|--------|----------------|
| | [nagisanzenin/claude-code-production-grade-plugin](https://github.com/nagisanzenin/claude-code-production-grade-plugin) | Receipt gates, subagent orchestration, 14 specialized agents |
| | [obra/superpowers](https://github.com/obra/superpowers) | Iron Laws, TDD discipline, verification-before-completion |
| | [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills) | Vertical slicing, incremental implementation, 5-axis review |

Every request is classified and routed through only the phases it needs:

| Mode | Pipeline |
|------|----------|
| **Build** | `DESIGN → PLAN → BUILD → REVIEW → HARDEN → VERIFY` |
| **Feature** | `DESIGN → PLAN → BUILD → VERIFY` |
| **Fix** | `DEBUG → BUILD → VERIFY` |
| **Review** | `REVIEW` |
| **Harden** | `REVIEW → HARDEN` |

---

## Quickstart

### Step 1 — Install

```bash
cp CLAUDE.md /path/to/your-project/
cp -r .agents/ /path/to/your-project/
cp -r .claude/ /path/to/your-project/
```

### Step 2 — Open your project in Claude Code

The session-start hook prints context automatically:

```
━━━ oh-my-god | Session Resume ━━━━━━━━━━━━━━━━━━━━━
  Last receipt: none
  Open spec:    none
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Step 3 — Start working

```
/oh-my-god <task>
```

Claude classifies the request, picks the right phases, and runs them automatically. No approval prompts except before BUILD starts.

---

## Use Cases

### Build a new feature

```
/oh-my-god add JWT authentication to the Express API
```

```
Mode: Feature
━━━ DESIGN ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Proposes: middleware approach vs library approach
→ You approve design              ← only gate

━━━ PLAN ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Creates task breakdown, exact file paths, no placeholders
→ automatic

━━━ BUILD ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
TDD: writes failing test → implements → watches go GREEN
→ automatic

━━━ VERIFY ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Runs test suite, attaches output as evidence
→ automatic
```

Receipt appended to `receipts.md`:
```
## 2026-04-13 14:32 | BUILD | JWT auth
- [x] Tests written and watched fail first (RED verified)
- [x] All tests pass — npm test: 8/8
- [x] No scope creep
- [x] Committed — feat: add JWT authentication
```

---

### Fix a bug

```
/debug the 500 error on POST /api/tasks when body is empty
```

```
Mode: Fix
━━━ DEBUG ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Reads full error + stack trace
Reproduces the bug consistently
Traces data flow to find root cause
States hypothesis: "missing body validation on line 42"

━━━ BUILD ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Writes test that reproduces the bug (RED)
Fixes root cause — not the symptom (GREEN)

━━━ VERIFY ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Runs full test suite — confirms fix, no regressions
```

---

### Review code

```
/review src/auth/middleware.ts
```

```
Mode: Review
5-axis analysis:
  Correctness  — edge cases, error paths tested?
  Readability  — can a peer understand in 6 months?
  Architecture — clean boundaries, no duplication?
  Security     — input validated, auth enforced?
  Performance  — N+1 queries, unbounded loops?

Findings rated: CRITICAL / REQUIRED / OPTIONAL / NIT
```

---

### Harden before launch

```
/harden
```

```
Mode: Harden
Runs REVIEW → HARDEN checklist:
  ✓ npm audit — 0 critical/high
  ✓ No secrets in git log
  ✓ Security headers configured
  ✓ Rate limits on auth endpoints
  ✓ Input validated at all boundaries
```

---

### Use a specialist skill directly

```
/oh-my-god review this spec as a product manager
/oh-my-god audit the API design
/oh-my-god review security of the payment flow
```

Any of the 49 skills can be invoked directly — no mode switching needed.

---

## Installation

**Prerequisites:** `bash`, `git`, `python3`

Run inside your project directory:

```bash
curl -fsSL https://raw.githubusercontent.com/chatre7/oh-my-god/master/install.sh | bash
```

Installs: `CLAUDE.md` · `.agents/skills/` (49) · `.claude/commands/` · `hooks/` · `stat.md`

```
━━━ oh-my-god installed ━━━━━━━━━━━━━━━━━━━━━━━━━━━
  CLAUDE.md              ✓
  .agents/skills/ (49)   ✓
  .claude/commands       ✓
  hooks/                 ✓
  stat.md                ✓
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Manual install

<details>
<summary>Claude Code</summary>

```bash
cp CLAUDE.md /path/to/your-project/
cp -r .agents/ /path/to/your-project/
cp -r .claude/ /path/to/your-project/
cp -r hooks/ /path/to/your-project/
```

</details>

<details>
<summary>Gemini CLI</summary>

```bash
gemini skills install /path/to/oh-my-god/.agents/skills/ --scope workspace
```

Or copy `GEMINI.md` + `gemini-extension.json` + `.agents/` into your project root.

</details>

<details>
<summary>Codex</summary>

Copy `AGENTS.md` + `.agents/` into your project root.

</details>

<details>
<summary>OpenCode</summary>

Copy `AGENTS.md` + `CLAUDE.md` + `.agents/` into your project root, then invoke with `use skill tool to load oh-my-god`.

</details>

---

## Usage

### Claude Code — slash commands

```
/oh-my-god build a user authentication system with JWT
/oh-my-god fix the 500 error on /api/tasks
/debug the race condition in the queue processor
/review my auth middleware
/harden before the launch
```

| Command | Mode | What happens |
|---------|------|--------------|
| `/oh-my-god <task>` | auto-classify | Full-cycle — Iron Laws enforced throughout |
| `/debug <issue>` | Fix | Root cause first, then BUILD → VERIFY |
| `/harden` | Harden | Adversarial review + security checklist |
| `/review` | Review | 5-axis: Correctness, Readability, Architecture, Security, Performance |
| `/build <task>` | Feature | TDD cycle — RED first, always |
| `/brainstorm` | — | Design + spec (HARD GATE before code) |
| `/spec` | — | 6-area specification |
| `/plan` | — | Implementation plan — no placeholders |
| `/test` | — | Run suite with evidence |
| `/code-simplify` | — | Reduce complexity |
| `/ship` | — | Staged deployment with rollback plan |
| `/write-plan` | — | Detailed plan |
| `/execute-plan` | — | Execute plan with checkpoints |

### Gemini CLI

Skills auto-activate — describe what you want:

```
build a user authentication system with JWT
fix the 500 error on /api/tasks
```

Or reference explicitly: `@.agents/skills/oh-my-god/SKILL.md — build a user authentication system`

> Gemini CLI does not support subagents — BUILD phase runs sequentially.

### Codex

```
Apply the instructions in .agents/skills/oh-my-god/SKILL.md to build a user authentication system
Apply the instructions in .agents/skills/oh-my-god/SKILL.md to fix the 500 error on /api/tasks
```

### OpenCode

```
use skill tool to load oh-my-god
build a user authentication system with JWT
```

> OpenCode supports subagents via `@mention` syntax.

---

## Solo Developer Mode

Express Mode is active by default — optimized for fast solo iteration.

| | Express (default) | Thorough | Meticulous |
|-|------------------|----------|------------|
| **Gates** | HARD GATE before BUILD only | Approve each phase | Approve every step |
| **Transitions** | Automatic | Manual per phase | Manual per step |
| **Review** | CRITICAL findings block | REQUIRED findings block | All findings block |
| **Best for** | Solo, fast iteration | Pre-release, team handoff | Security audit, high-stakes |

Switch modes by saying: `"use Thorough mode"` or `"use Meticulous mode"`

### Receipts

Every completed phase appends a checklist to `receipts.md` in your project root:

```
## 2026-04-13 14:32 | BUILD | Task-3
- [x] Tests written and watched fail first (RED verified)
- [x] All tests pass — npm test: 6/6
- [x] No scope creep — touched only specified files
- [x] Committed — feat: add login endpoint
```

### Session Resume

Each session starts with an automatic context summary — no re-explaining where you left off:

```
━━━ oh-my-god | Session Resume ━━━━━━━━━━━━━━━━━━━━━
  Last receipt: 2026-04-13 14:32 | BUILD | Task-3 (today)
  Open spec:    2026-04-13-auth-design.md
  Top skills:   tdd(8x), debugging(5x), spec(3x)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

Reads `receipts.md` from the current project directory — each project tracked separately.

### Skill usage tracking

`stat.md` tracks which skills you use and how often — logged automatically on every invocation (including nested calls from within `oh-my-god`).

To log manually:

```bash
bash hooks/log-skill.sh oh-my-god
bash hooks/log-skill.sh test-driven-development
```

### Outcome tracking

Log whether a session succeeded or required a rollback — tracked per skill in `stat.md`:

```bash
bash hooks/log-skill.sh oh-my-god success    # all tests pass, task complete
bash hooks/log-skill.sh oh-my-god rollback   # had to revert
```

`stat.md` accumulates success rate over time:

```
| Skill         | Uses | ✓ | ✗ | Score | Last used  |
|---------------|------|---|---|-------|------------|
| oh-my-god     |   12 | 10| 2 |  83%  | 2026-04-13 |
| brainstorming |    8 |  7| 1 |  87%  | 2026-04-12 |
```

### Receipt decay

Receipts older than 30 days are automatically moved to an `[ARCHIVED]` section at session start — keeping `receipts.md` focused on recent work without losing history.

```
receipts.md
├── [ACTIVE]   — last 30 days, read for context
└── [ARCHIVED] — older entries, preserved but deprioritized
```

No configuration needed — runs automatically via the session-start hook.

### Crystallization

Distill repeated patterns from `receipts.md` into permanent lessons in `SKILL.md`.

After VERIFY, oh-my-god checks automatically. When receipts accumulate ≥ 5 since the last crystallize, a nudge appears:

```
  💡 7 receipts since last crystallize — run /crystallize to distill lessons into SKILL.md
```

Run crystallization manually at any time:

```
/crystallize
```

Toggle the nudge:

```
/crystallize on    # enable (default)
/crystallize off   # disable
```

Crystallization is the only feature that uses LLM tokens — all others (outcome logging, decay, nudge check) are pure bash.

---

## Skills (49 total)

<details>
<summary>From Superpowers (13)</summary>

`brainstorming` `test-driven-development` `verification-before-completion` `systematic-debugging` `subagent-driven-development` `writing-plans` `executing-plans` `dispatching-parallel-agents` `using-git-worktrees` `finishing-a-development-branch` `requesting-code-review` `receiving-code-review` `writing-skills`

</details>

<details>
<summary>From Agent Skills (20)</summary>

`spec-driven-development` `planning-and-task-breakdown` `incremental-implementation` `context-engineering` `code-review-and-quality` `security-and-hardening` `performance-optimization` `test-driven-development` `debugging-and-error-recovery` `git-workflow-and-versioning` `ci-cd-and-automation` `shipping-and-launch` `documentation-and-adrs` `frontend-ui-engineering` `api-and-interface-design` `idea-refine` `source-driven-development` `deprecation-and-migration` `code-simplification` `browser-testing-with-devtools`

</details>

<details>
<summary>From Production-Grade Plugin (13)</summary>

`production-grade` `product-manager` `solution-architect` `software-engineer` `frontend-engineer` `qa-engineer` `security-engineer` `code-reviewer` `devops` `sre` `technical-writer` `polymath` `skill-maker`

</details>

---

## Platform support

| Platform | Subagents | Notes |
|----------|-----------|-------|
| Claude Code | Full | Native — recommended |
| Gemini CLI | Sequential fallback | See `.agents/skills/oh-my-god/references/gemini-tools.md` |
| Codex | Sequential fallback | See `.agents/skills/oh-my-god/references/codex-tools.md` |
| OpenCode | Via `@mention` | See `.agents/skills/oh-my-god/references/opencode-tools.md` |

---

## License

MIT
