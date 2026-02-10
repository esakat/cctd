# CCTD File Format Specification

## Directory Structure

```
.tasks/
├── index.md          # Lightweight index (stories + tasks)
├── stories/
│   ├── S001.md       # Story detail
│   └── S002.md
└── tasks/
    ├── S001-001.md   # Task detail
    ├── S001-002.md
    └── S002-001.md
```

## index.md

Two sections separated by blank line. Lines starting with `#` are comments/headers.

### Stories Section

```
# Stories
# ID|Status|Title|Labels|Priority|Created
S001|DEFINED|ユーザー認証の実装|auth,backend|high|2026-02-10
S002|BACKLOG|音声生成パイプライン|audio|high|2026-02-10
```

- **ID**: `S` + 3-digit zero-padded (S001, S002, ...)
- **Status**: `BACKLOG`, `DEFINED`, `IN_PROGRESS`, `DONE`

### Tasks Section

```
# Tasks
# ID|Status|Title|Agent|Model|Deps|Created
S001-001|AI_READY|認証API設計|backend-architect|opus|-|2026-02-10
S001-002|BACKLOG|ログインUI|frontend-architect|sonnet|S001-001|2026-02-10
```

- **ID**: `{StoryID}-{3-digit}` (S001-001, S001-002, ...)
- **Status**: `BACKLOG`, `DEFINED`, `AI_READY`, `IN_PROGRESS`, `TESTING`, `REVIEW`, `DONE`
- **Agent**: Claude Code subagent_type
- **Model**: `opus` (default) or `sonnet` (simple/routine tasks)
- **Deps**: Comma-separated task IDs or `-`

## Story File (.tasks/stories/S001.md)

```markdown
# {Title}
- ID: S001
- Status: DEFINED
- Labels: auth, backend
- Priority: high
- Created: 2026-02-10

## User Story
{User story description. What the user wants to achieve and why.}

## Acceptance Criteria
- [ ] {Criterion 1}
- [ ] {Criterion 2}
- [ ] {Criterion 3}

## Work Log
[2026-02-10] Story作成
```

## Task File (.tasks/tasks/S001-001.md)

```markdown
# {Title}
- ID: S001-001
- Story: S001
- Status: AI_READY
- Agent: backend-architect
- Model: opus
- Priority: high
- Created: 2026-02-10
- Deps: -
- Blocks: S001-002

## Spec
{SDD specification. When AI_READY, this must be detailed enough for the
assigned agent to execute without additional context.

Include:
- What to implement
- Technical approach / constraints
- Input/output expectations
- Files to create or modify
- Acceptance criteria for this task}

## Work Log
[2026-02-10] タスク作成
```

### AI_READY Checklist

A task is AI_READY when:
- [ ] Spec section is complete and self-contained
- [ ] Agent type is assigned
- [ ] Model is set (opus/sonnet)
- [ ] All Deps are DONE or not blocking
- [ ] Expected output (files, behavior) is clearly defined

## Model Selection Guide

| Model | When to use | Examples |
|---|---|---|
| `opus` | Complex design, architecture, multi-file, security-sensitive | API設計, DB設計, 認証実装, アーキテクチャ決定 |
| `sonnet` | Simple/routine, single-file, config, boilerplate | 設定ファイル作成, 型定義, テストデータ, リネーム |

Default: `opus`. Use `sonnet` only when the task is clearly routine/mechanical.

## Available Agent Types

| Agent | Use For |
|---|---|
| `plan` | Architecture planning, design decisions |
| `backend-architect` | Backend system design, APIs, data models |
| `frontend-architect` | UI components, layouts, UX |
| `general-purpose` | General implementation, scripting |
| `quality-engineer` | Testing, test writing, QA |
| `security-engineer` | Security review, vulnerability analysis |
| `performance-engineer` | Performance optimization |
| `refactoring-expert` | Code cleanup, refactoring |
| `Explore` | Codebase research, investigation |
| `deep-research-agent` | Web research, documentation lookup |

## Status Transition Rules

### Story Status
```
BACKLOG ──→ DEFINED ──→ IN_PROGRESS ──→ DONE
```
- → DEFINED: Requirements clarified with user
- → IN_PROGRESS: Any child task moves to IN_PROGRESS+
- → DONE: All child tasks are DONE

### Task Status
```
BACKLOG ──→ DEFINED ──→ AI_READY ──→ IN_PROGRESS ──→ TESTING ──→ REVIEW ──→ DONE
```
- → DEFINED: Scope and requirements clarified
- → AI_READY: Spec complete, agent assigned, model set, deps clear
- → IN_PROGRESS: Agent started work
- → TESTING: Implementation done, QA agent verifying
- → REVIEW: Tests pass, human reviews
- → DONE: Approved and merged/accepted
