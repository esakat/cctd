---
name: cctd
description: "Claude Code Task Dashboard - SDD-oriented task management for Claude Code projects. Use when the user invokes /cctd or discusses task management, user stories, backlog, or project tracking. Manages User Stories (parent) and Tasks (children) with AI agent workflow statuses. All data stored as markdown in .tasks/ directory."
---

# CCTD

SDD-oriented task management. Stories (parent) → Tasks (children). Data in `.tasks/`.

## Routing

Parse $ARGUMENTS first word to determine command. Load the corresponding reference file ONLY for that command.

| First word | Reference to read | Summary |
|---|---|---|
| (empty) | references/cmd-dashboard.md | Stories overview |
| `add` | references/cmd-add.md | New story or task |
| `view` | references/cmd-view.md | Detail display |
| `status` | references/cmd-status.md | Change status |
| `done` | references/cmd-status.md | Shortcut for DONE |
| `edit` | references/cmd-edit.md | Edit story/task |
| `list` | references/cmd-list.md | Flat task list |
| `init` | Run: `bash {SKILL_DIR}/scripts/init-tasks.sh` | Setup .tasks/ |
| `help` | Show this routing table + status flow below | Help |

ID format: `S001` = story, `S001-001` = task.

Do NOT use AskUserQuestion after commands. Display and stop.

## Status Flow

Stories: `BACKLOG ⚪ → DEFINED 🔵 → IN_PROGRESS 🟡 → DONE 🟢`
Tasks: `BACKLOG ⚪ → DEFINED 🔵 → AI_READY 🟣 → IN_PROGRESS 🟡 → TESTING 🟠 → REVIEW 🔶 → DONE 🟢`

## File Format

See references/format.md for data structure specs.
