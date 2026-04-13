# oh-my-god

A unified AI engineering skill synthesized from three production-grade systems.

| Source | Contribution |
|--------|-------------|
| [nagisanzenin/claude-code-production-grade-plugin](https://github.com/nagisanzenin/claude-code-production-grade-plugin) | Receipt gates, subagent orchestration, 14 specialized agents |
| [obra/superpowers](https://github.com/obra/superpowers) | Iron Laws, TDD discipline, subagent-driven development, verification |
| [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills) | Vertical slicing, incremental implementation, 5-axis review, Google engineering practices |

---

## What it does

`oh-my-god` enforces five Iron Laws that cannot be skipped:

```
IRON LAW 1: NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST
IRON LAW 2: NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE
IRON LAW 3: NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST
IRON LAW 4: NO PHASE ADVANCE WITHOUT A WRITTEN RECEIPT
IRON LAW 5: NO BUILD WITHOUT AN APPROVED DESIGN
```

Every request is classified into a mode and runs only the phases it needs:

| Mode | Phases |
|------|--------|
| Build | DESIGN → PLAN → BUILD → REVIEW → HARDEN → VERIFY |
| Feature | DESIGN → PLAN → BUILD → VERIFY |
| Fix | DEBUG → BUILD → VERIFY |
| Review | REVIEW only |
| Harden | REVIEW + HARDEN |

---

## Installation

### Claude Code

```bash
/plugin install --plugin-dir /path/to/oh-my-god
```

Or copy directly into your project:

```bash
cp CLAUDE.md /path/to/your-project/
cp -r skills/ /path/to/your-project/
cp -r .claude/ /path/to/your-project/
```

### Gemini CLI

```bash
gemini skills install /path/to/oh-my-god/skills/ --scope workspace
```

Or copy `GEMINI.md` + `skills/` into your project root.

### Codex

Copy `AGENTS.md` + `skills/` into your project root.

### OpenCode

Copy `AGENTS.md` + `CLAUDE.md` + `skills/` into your project root, then:

```
use skill tool to load oh-my-god
```

---

## Usage

### Claude Code

Use slash commands:

```
/oh-my-god build a user authentication system with JWT
/oh-my-god add email validation to the signup form
/oh-my-god fix the 500 error on /api/tasks
/oh-my-god review my auth middleware
```

Or individual skills:

| Command | Mode | Description |
|---------|------|-------------|
| `/oh-my-god <task>` | auto-classify | Full-cycle unified skill |
| `/debug <issue>` | Fix | DEBUG → BUILD → VERIFY |
| `/harden` | Harden | REVIEW + HARDEN |
| `/review` | Review | 5-axis adversarial code review |
| `/build <task>` | Feature | TDD cycle for a task |
| `/spec` | — | Create a 6-area specification |
| `/plan` | — | Write implementation plan (no placeholders) |
| `/brainstorm` | — | Design before code (HARD GATE) |
| `/test` | — | Run test suite with evidence |
| `/code-simplify` | — | Reduce complexity |
| `/ship` | — | Staged deployment with rollback plan |
| `/write-plan` | — | Write detailed plan |
| `/execute-plan` | — | Execute plan with checkpoints |

### Gemini CLI

Skills auto-activate — just describe what you want:

```
build a user authentication system with JWT
add email validation to the signup form
fix the 500 error on /api/tasks
review my auth middleware
```

Or reference the skill explicitly:

```
@skills/oh-my-god/SKILL.md — build a user authentication system
```

> Note: Gemini CLI does not support subagents. The BUILD phase runs sequentially in the same session.

### Codex

Reference the skill explicitly:

```
Apply the instructions in skills/oh-my-god/SKILL.md to build a user authentication system
Apply the instructions in skills/oh-my-god/SKILL.md to fix the 500 error on /api/tasks
Apply the instructions in skills/oh-my-god/SKILL.md to review my auth middleware
```

> Note: Codex reads AGENTS.md which loads CLAUDE.md. Skills may also auto-activate based on intent.

### OpenCode

Load the skill explicitly via the `skill` tool, then describe your task:

```
use skill tool to load oh-my-god
build a user authentication system with JWT
```

Or let the agent auto-select based on intent:

```
build a user authentication system with JWT
```

> Note: OpenCode supports subagents via `@mention` syntax.

---

## Solo Developer Mode

Express Mode is active by default — optimized for solo use.

### Engagement modes

| Mode | Approval gates | How to activate |
|------|---------------|-----------------|
| **Express** (default) | HARD GATE before BUILD only | automatic |
| Thorough | Approve each phase | "use Thorough mode" |
| Meticulous | Approve every step | "use Meticulous mode" |

The only gate that remains in Express Mode is the design approval before BUILD starts. All other phase transitions happen automatically.

### Receipts

Per-task and final receipts are appended to `receipts.md` in your project root as markdown checklists:

```markdown
## 2026-04-13 14:32 | BUILD | Task-3
- [x] Tests written and watched fail first (RED verified)
- [x] All tests pass — npm test: 6/6
- [x] No scope creep — touched only specified files
- [x] Committed — feat: add login endpoint
```

### Session-start hook

`hooks/session-start.sh` prints context at the start of every session so the agent knows where things left off:

```
━━━ oh-my-god | Session Resume ━━━━━━━━━━━━━━━━━━━━━
  Last receipt: 2026-04-13 14:32 | BUILD | Task-3 (today)
  Open spec:    2026-04-13-auth-design.md
  Top skills:   tdd(8x), debugging(5x), spec(3x)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

Reads `receipts.md` from the **current project directory** (`$PWD`) — each project has its own receipt log. Registered in `hooks/hooks.json` — runs automatically on `SessionStart`.

### stat.md

`stat.md` at the plugin root tracks which skills you use and how often:

```markdown
| Skill | Uses | Last used |
|-------|------|-----------|
| oh-my-god | 12 | 2026-04-13 |
| test-driven-development | 8 | 2026-04-13 |
```

Update with the log-skill script:

```bash
bash hooks/log-skill.sh oh-my-god
bash hooks/log-skill.sh test-driven-development
```

Or update manually. The session-start hook surfaces the top 3 automatically each session.

---

## Skills included (46 total)

### oh-my-god (synthesized)
The unified skill that orchestrates all phases and Iron Laws.

### From Superpowers
`brainstorming` `test-driven-development` `verification-before-completion`
`systematic-debugging` `subagent-driven-development` `writing-plans`
`executing-plans` `dispatching-parallel-agents` `using-git-worktrees`
`finishing-a-development-branch` `requesting-code-review` `receiving-code-review`
`writing-skills`

### From Agent Skills
`spec-driven-development` `planning-and-task-breakdown` `incremental-implementation`
`context-engineering` `code-review-and-quality` `security-and-hardening`
`performance-optimization` `test-driven-development` `debugging-and-error-recovery`
`git-workflow-and-versioning` `ci-cd-and-automation` `shipping-and-launch`
`documentation-and-adrs` `frontend-ui-engineering` `api-and-interface-design`
`idea-refine` `source-driven-development` `deprecation-and-migration`
`code-simplification` `browser-testing-with-devtools`

### From Production-Grade Plugin
`production-grade` `product-manager` `solution-architect` `software-engineer`
`frontend-engineer` `qa-engineer` `security-engineer` `code-reviewer`
`devops` `sre` `technical-writer` `polymath` `skill-maker`

---

## Platform support

| Platform | Subagents | Notes |
|----------|-----------|-------|
| Claude Code | Full | Native experience |
| Gemini CLI | No — sequential fallback | See `skills/oh-my-god/references/gemini-tools.md` |
| Codex | No — sequential fallback | See `skills/oh-my-god/references/codex-tools.md` |
| OpenCode | Via `@mention` | See `skills/oh-my-god/references/opencode-tools.md` |

---

## License

MIT
