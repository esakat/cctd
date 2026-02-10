# CCTD - Claude Code Task Dashboard

SDD(Spec-Driven Development)指向のタスク管理 Skill for Claude Code。
User Stories（親）と Tasks（子）をマークダウンで管理し、AIエージェントワークフローに最適化されたステータスフローを提供します。

## Features

- **Story/Task 階層管理**: User Story を親、Task を子として管理
- **AIエージェント対応**: タスクに担当エージェント（subagent_type）を指定可能
- **SDD ステータスフロー**: BACKLOG → DEFINED → AI_READY → IN_PROGRESS → TESTING → REVIEW → DONE
- **マークダウンベース**: `.tasks/` ディレクトリにすべてのデータを保存。外部ツール不要
- **依存関係管理**: タスク間の Deps / Blocks を追跡

## Visualizer

[cctd-web](https://github.com/esakat/cctd-web) でタスクの状態をビジュアルに確認できます。

## Install

### As Claude Code Skill

```bash
# プロジェクトに skill/ ディレクトリをコピー
cp -r skill/cctd /path/to/your-project/.claude/skills/cctd
cp skill/cctd.skill /path/to/your-project/.claude/skills/cctd.skill
```

### As Slash Commands (Legacy)

```bash
# .claude/commands/ にコマンドファイルをコピー
cp -r .claude/commands/ /path/to/your-project/.claude/commands/
```

## Usage

### Skill（推奨）

```
/cctd              # ダッシュボード表示
/cctd add タイトル  # ストーリー追加
/cctd add S001 タスクタイトル --agent=backend-architect  # タスク追加
/cctd view S001    # ストーリー詳細
/cctd view S001-001 # タスク詳細
/cctd status S001-001 IN_PROGRESS  # ステータス変更
/cctd done S001-001  # 完了
/cctd list           # タスク一覧
/cctd edit S001 ACに「2FA対応」追加  # 編集
/cctd init           # .tasks/ ディレクトリ初期化
```

### Slash Commands (Legacy)

```
/tasks              # タスク一覧
/task-add タイトル   # タスク追加
/task-view 001      # タスク詳細
/task-done 001      # タスク完了
/task-edit 001 変更内容  # タスク編集
```

## Status Flow

### Stories
```
BACKLOG ⚪ → DEFINED 🔵 → IN_PROGRESS 🟡 → DONE 🟢
```

### Tasks
```
BACKLOG ⚪ → DEFINED 🔵 → AI_READY 🟣 → IN_PROGRESS 🟡 → TESTING 🟠 → REVIEW 🔶 → DONE 🟢
```

## File Structure

```
.tasks/
├── index.md          # Lightweight index (stories + tasks)
├── stories/
│   ├── S001.md       # Story detail
│   └── S002.md
└── tasks/
    ├── S001-001.md   # Task detail
    └── S001-002.md
```

## CLAUDE.md Integration

プロジェクトの `CLAUDE.md` に以下を追加すると、Claude Code がタスク管理の文脈を理解します:

```markdown
## タスク管理システム
プロジェクト内蔵のタスク管理。外部ツール不要。

### コマンド
- `/cctd` - タスクダッシュボード（推奨）
- `/tasks` - タスク一覧表示
- `/task-add` - 新規タスク追加
- `/task-done` - タスク完了
- `/task-view` - タスク詳細表示
- `/task-edit` - タスク編集

### ファイル構造
- `.tasks/index.md` - タスクインデックス
- `.tasks/stories/{ID}.md` - ストーリー詳細
- `.tasks/tasks/{ID}.md` - タスク詳細
```

## License

MIT
