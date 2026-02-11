---
name: cctd:list
description: "Show overview of all stories and tasks. Quick status check with filtering by status, priority, agent, model, or story ID."
---

# CCTD List

Read `.tasks/index.md` and display stories + tasks overview.
Display and stop. No AskUserQuestion.

## Display Format

### Stories
```
📋 Stories ({done}/{total})

| ID   | Status | Title          | Progress | Priority |
|------|--------|----------------|----------|----------|
```
Progress = DONE tasks / total tasks per story.

### Tasks
```
🔧 Tasks ({done}/{total})

| ID       | Status | Title     | Agent    | Model  | Deps | Priority |
|----------|--------|-----------|----------|--------|------|----------|
```

## Status Icons

BACKLOG=⚪  DEFINED=🔵  AI_READY=🟣  IN_PROGRESS=🟡  TESTING=🟠  REVIEW=🔶  DONE=🟢

## Filters

$ARGUMENTS applied as AND filters:
- Status: backlog, defined, ai_ready, in_progress, testing, review, done
- Agent: backend-architect, frontend-architect, etc.
- Model: opus, sonnet
- Story: S001
- Priority: high, medium, low

## Footer

End with:

```
💡 ヒント:
  /cctd:view {ID}    — 詳細表示
  /cctd:start {ID}   — 作業開始
  /cctd:spec          — 新しいストーリーを作成
```
