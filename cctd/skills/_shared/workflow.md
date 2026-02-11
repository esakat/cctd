# CCTD Team Manager Workflow

Claude acts as team manager when working with CCTD tasks. This document defines autonomous behavior rules.

## ⚠️ Status Update Procedure (MANDATORY)

**All status updates MUST follow this procedure. Partial updates are prohibited.**

1. Update `.tasks/tasks/{ID}.md` (or `.tasks/stories/{ID}.md`) — change the `- Status:` line
2. Append to `## Work Log` in the same file: `[YYYY-MM-DD] {action description}`
3. Update the corresponding line in `.tasks/index.md`
4. Check and apply story auto-status rules:
   - Any child task → IN_PROGRESS: story → IN_PROGRESS
   - All child tasks → DONE: story → DONE
   (Story updates also follow steps 1-3 above)

**⚠️ Updating index.md alone is PROHIBITED.** cctd-web reads individual files with priority — index.md-only updates will NOT appear in the board or activity log.

## Claude Code Tasks Integration

When executing CCTD story work, use Claude Code's standard Tasks system as the execution engine.

### Starting Work (via `/cctd:start` or natural language)
1. Read CCTD task files from `.tasks/tasks/`
2. Create standard Tasks via TaskCreate with `metadata: { cctdId: "{TaskID}" }`
3. Map CCTD Deps to standard Tasks blockedBy
4. Update CCTD task status per the Status Update Procedure above

### Progress Sync
When a standard Task status changes, sync to CCTD:

| Standard Task Event | CCTD Sync Action |
|---|---|
| TaskUpdate → in_progress | CCTD task → IN_PROGRESS (file + index + Work Log) |
| TaskUpdate → completed | CCTD task → DONE (file + index + Work Log) |
| All story tasks completed | CCTD story → DONE (file + index + Work Log) |

### Status Mapping
| Standard Tasks | CCTD Status |
|---|---|
| pending | AI_READY |
| in_progress | IN_PROGRESS |
| completed | DONE |

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
  4. Create standard Task via TaskCreate (with metadata.cctdId)
     OR spawn teammate via Task tool:
     - subagent_type = task's Agent field
     - model = task's Model field ("opus" or "sonnet")
     - prompt = task's Spec section + relevant context
  5. Update task status → IN_PROGRESS (follow Status Update Procedure)
  6. Log: [{date}] work started (agent: {Agent}, model: {Model})
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
| Work starts | → IN_PROGRESS |
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
Follow the **Status Update Procedure** at the top of this document.

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
