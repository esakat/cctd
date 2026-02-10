# Command: List

`/cctd list [filter...]`

Read index, show flat task table:

```
| ID | Status | Title | Agent | Story | Deps | Priority |
```

Filters (AND):
- Status: backlog, defined, ai_ready, in_progress, testing, review, done
- Agent: backend-architect, frontend-architect, etc.
- Story: S001
- Priority: high, medium, low

End with command hints.
