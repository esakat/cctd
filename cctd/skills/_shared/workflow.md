# CCTD Team Manager Workflow

Claude acts as team manager when working with CCTD tasks. This document defines autonomous behavior rules.

## Reading State

1. Read `.tasks/index.md` to understand current stories and tasks
2. Parse pipe-delimited format per `format.md`
3. Identify actionable items by status

## Autonomous Task Management

### When user gives abstract instructions
1. Check if related story exists in `.tasks/`
2. If no → suggest `/cctd:spec` for interactive planning
3. If yes → identify tasks, check statuses, proceed with execution

### Dispatching Teammates

When AI_READY tasks exist and team execution is requested:

```
For each AI_READY task:
  1. Read .tasks/tasks/{ID}.md
  2. Extract: Agent, Model, Spec, Deps
  3. Verify all Deps are DONE
  4. Spawn teammate via Task tool:
     - subagent_type = task's Agent field
     - model = task's Model field ("opus" or "sonnet")
     - prompt = task's Spec section + relevant context
  5. Update task status → IN_PROGRESS
  6. Log: [{date}] teammate spawn (agent: {Agent}, model: {Model})
```

### Model Selection

- Task `Model: opus` → spawn with `model: "opus"`
- Task `Model: sonnet` → spawn with `model: "sonnet"`
- If Model field is missing → default to `opus`

### Parallel Execution Rules

- Tasks with no mutual dependencies → run in parallel
- Tasks where A blocks B → run sequentially (A first)
- Group independent tasks for maximum parallelism

### Status Updates

| Event | Status Change |
|---|---|
| Teammate starts work | → IN_PROGRESS |
| Implementation complete | → TESTING (if QA task exists) or REVIEW |
| QA passes | → REVIEW |
| Human approves | → DONE |

### Dependency Resolution

When a task completes:
1. Find tasks that list it in Deps
2. Check if ALL their deps are now DONE
3. If yes → those tasks become eligible for dispatch
4. Log dependency resolution in Work Log

### Story Auto-Status

- Any child task → IN_PROGRESS: story → IN_PROGRESS
- All child tasks → DONE: story → DONE

## File Operations

All task management (create, edit, status update) is done by directly editing `.tasks/` files.
Claude does NOT need slash commands for this — read and write the markdown files directly.

### Creating a Story
1. Determine next ID (max existing + 1)
2. Create `.tasks/stories/{ID}.md` per format.md template
3. Append line to Stories section in `index.md`

### Creating a Task
1. Determine next task number under the story
2. Create `.tasks/tasks/{ID}.md` per format.md template
3. Append line to Tasks section in `index.md`
4. If story is BACKLOG → auto-promote to DEFINED

### Updating Status
1. Update status in `.tasks/tasks/{ID}.md` (or stories)
2. Update corresponding line in `index.md`
3. Append Work Log entry: `[{date}] Status → {NEW_STATUS}`
4. Check and apply story auto-status rules
5. Check and resolve dependencies

## Error Handling

- Teammate fails → keep task IN_PROGRESS, log error in Work Log
- Spec insufficient → revert to DEFINED, note what's missing
- Blocked by unclear requirements → flag to user, do not proceed
- Circular dependencies → flag to user immediately

## Work Log Format

All status changes and actions append to the relevant file's Work Log:
```
[{YYYY-MM-DD}] {action description}
```
