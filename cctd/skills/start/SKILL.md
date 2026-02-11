---
name: cctd:start
description: "Start working on a CCTD story. Converts AI_READY tasks to Claude Code standard Tasks, sets up dependencies, and begins execution. Usage: /cctd:start S001"
argument-hint: <Story ID>
---

# CCTD Start

Begin execution of a CCTD story by bridging to Claude Code's standard Tasks system.

Read `{SKILL_DIR}/../_shared/format.md` for file format specs.
Read `{SKILL_DIR}/../_shared/workflow.md` for sync rules.

## Input

$ARGUMENTS = Story ID (e.g., S001)

If no argument provided:
1. Read `.tasks/index.md`
2. List stories with status DEFINED or IN_PROGRESS
3. Ask user to select one

## Execution Flow

### Step 1: Read Story & Tasks
1. Read `.tasks/stories/{StoryID}.md`
2. Read `.tasks/index.md` to get all child task IDs
3. Read each `.tasks/tasks/{TaskID}.md`
4. Display story summary and task overview

### Step 2: Generate Standard Tasks
For each task with status AI_READY or DEFINED (with Spec):

```
TaskCreate:
  subject: task's Title
  description: task's Spec section (full content)
  activeForm: task's Title + "を実装中"
  metadata:
    cctdId: "{TaskID}"
    agent: "{Agent field}"
    model: "{Model field}"
```

Build a mapping table: CCTD TaskID → Standard Task ID

### Step 3: Set Dependencies
For each generated standard task:
- Read the CCTD task's Deps field
- Look up corresponding standard Task IDs from the mapping table
- Apply: `TaskUpdate({ taskId, addBlockedBy: [mapped IDs] })`

### Step 4: Update CCTD Status
1. Update story status → IN_PROGRESS (individual file + index.md + Work Log)
2. Update each converted task status → IN_PROGRESS if no blockers, else keep AI_READY
3. Follow the status update procedure in workflow.md (individual file first, then index.md, then Work Log)

### Step 5: Display Summary
```
📋 Story {ID}: {Title}
   Status: {old} → IN_PROGRESS

🚀 標準Tasks生成完了:
   Task {stdId}: {title} ({cctdId}) → {ready|blocked by ...}
   ...

▶ 依存なしのタスクから作業を開始します。
```

### Step 6: Begin Work
Start working on unblocked tasks. As work progresses:
- Standard TaskUpdate → in_progress: sync CCTD task → IN_PROGRESS
- Standard TaskUpdate → completed: sync CCTD task → DONE
- Always follow sync rules in workflow.md

## Sync Rules

On every standard Task status change, update the corresponding CCTD task:

| Standard Tasks Event | CCTD Action |
|---|---|
| TaskUpdate → in_progress | Task file Status → IN_PROGRESS, Work Log append |
| TaskUpdate → completed | Task file Status → DONE, Work Log append |
| All tasks completed | Story file Status → DONE, Work Log append |

**Always update**: individual file Status + Work Log + index.md line. Never index.md alone.
