# OpenCode — Tool Mapping for oh-my-god skill

Skills in oh-my-god use Claude Code tool names. When running on OpenCode, use these equivalents:

| Skill references | OpenCode equivalent |
|-----------------|-------------------|
| `Read` (file reading) | Native file tools |
| `Write` (file creation) | Native file tools |
| `Edit` (file editing) | Native file tools |
| `Bash` (run commands) | Native shell tools |
| `Grep` (search content) | Native search tools |
| `Glob` (search files by name) | Native file listing |
| `TodoWrite` (task tracking) | `todowrite` |
| `Skill` tool (invoke skill) | OpenCode native `skill` tool |
| `Task` (dispatch subagent) | `@mention` syntax |
| `WebSearch` | Web tools if available |

## Subagent Support

OpenCode supports subagent dispatch via `@mention` syntax. The oh-my-god subagent-driven development flow maps as:

- Dispatch implementer → `@agent implement: [task text]`
- Dispatch spec reviewer → `@agent review-spec: [task + spec section]`
- Dispatch code quality reviewer → `@agent review-quality: [git diff + criteria]`

## Usage

OpenCode discovers skills from `skills/` directory automatically. The agent reads AGENTS.md which redirects to CLAUDE.md for the activation instructions.

To activate manually:
```
use skill tool to load oh-my-god
```

Or let the agent select it automatically based on your request — the skill description is optimized for auto-discovery.
