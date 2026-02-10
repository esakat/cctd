---
name: view
description: "Show detailed view of a story or task. Auto-detects type by ID format: S001 = story, S001-001 = task."
---

# CCTD View

$ARGUMENTS = ID. Auto-detect story (S001) or task (S001-001).
Display and stop. No AskUserQuestion.

No ID → show: `使い方: /cctd:view {ID}  (例: S001, S001-001)`

## Story View

Read `.tasks/stories/{ID}.md` + child tasks from index.

```
┌──────────────────────────────────────────────┐
│ 📖 {ID}: {Title}                             │
├──────────────────────────────────────────────┤
│ Status / Priority / Labels / Created          │
└──────────────────────────────────────────────┘

## User Story
{content}

## Acceptance Criteria
{checklist}

## Tasks
| ID | Status | Title | Agent | Model | Deps |

## Work Log
```

## Task View

Read `.tasks/tasks/{ID}.md`.

```
┌──────────────────────────────────────────────┐
│ 🔧 {ID}: {Title}                             │
│ Story: {StoryID} - {StoryTitle}               │
├──────────────────────────────────────────────┤
│ Status / Agent / Model / Priority / Deps      │
└──────────────────────────────────────────────┘

## Spec
{content}

## Work Log
```

Footer: `/cctd:spec {ID}` `/cctd:list`
