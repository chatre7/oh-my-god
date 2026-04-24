# Gemini CLI — Tool Mapping for oh-my-god skill

Skills in oh-my-god use Claude Code tool names. When running on Gemini CLI, use these equivalents:

| Skill references | Gemini CLI equivalent |
|-----------------|----------------------|
| `Read` (file reading) | `read_file` |
| `Write` (file creation) | `write_file` |
| `Edit` (file editing) | `replace` |
| `Bash` (run commands) | `run_shell_command` |
| `Grep` (search content) | `grep_search` |
| `Glob` (search files by name) | `glob` |
| `TodoWrite` (task tracking) | `write_todos` / `tracker_create_task` |
| `WebSearch` | `google_web_search` |
| `WebFetch` | `web_fetch` |
| `Task` (dispatch subagent) | No equivalent — fall back to single-session execution |

## Subagent Limitation

Gemini CLI has no equivalent to Claude Code's `Task` tool for dispatching subagents.

When the oh-my-god skill calls for subagent-driven development (Phase 3: BUILD), fall back to:
- Execute each task sequentially in the same session
- Run the 2-stage review (spec compliance, then code quality) as inline evaluation steps
- Use `tracker_create_task` for progress tracking

## Gemini-Specific Advantages

These Gemini CLI tools enhance the skill where applicable:

| Tool | Use in oh-my-god |
|------|-----------------|
| `enter_plan_mode` / `exit_plan_mode` | Use during DESIGN and PLAN phases (read-only research before acting) |
| `save_memory` | Persist receipt data and design decisions across sessions |
| `ask_user` | Use for DESIGN gate approvals and phase transitions |
| `tracker_create_task` | Richer task tracking for BUILD phase |

## Usage

Gemini CLI auto-discovers skills from `.gemini/skills/` or GEMINI.md references.

To activate manually:
```
@skills/oh-my-god/SKILL.md — apply the oh-my-god skill to this task
```
