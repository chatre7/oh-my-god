# Codex — Tool Mapping for oh-my-god skill

Skills in oh-my-god use Claude Code tool names. When running on OpenAI Codex, use these equivalents:

| Skill references | Codex equivalent |
|-----------------|-----------------|
| `Read` (file reading) | `read_file` |
| `Write` (file creation) | `write_file` |
| `Edit` (file editing) | `edit_file` |
| `Bash` (run commands) | `shell` |
| `Grep` (search content) | `search` |
| `Glob` (search files by name) | `list_files` |
| `TodoWrite` (task tracking) | Internal notes / markdown file |
| `WebSearch` | `search_web` (if available) |
| `WebFetch` | `fetch_url` (if available) |
| `Task` (dispatch subagent) | No equivalent — fall back to sequential execution |

## Subagent Limitation

Codex does not support subagent dispatch. When the oh-my-god skill calls for subagent-driven development, fall back to:
- Sequential task execution in the current session
- Inline 2-stage review (spec compliance check, then code quality check)
- Use markdown task lists for progress tracking

## Usage

Because Codex reads AGENTS.md (which redirects to CLAUDE.md), the oh-my-god skill activates via the CLAUDE.md instructions. When you invoke a task that matches the skill description, the agent should automatically apply it.

To manually reference the skill:
```
Apply the instructions in skills/oh-my-god/SKILL.md to this task.
```
