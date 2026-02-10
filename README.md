# CCTD - Claude Code Task Dashboard

SDD(Spec-Driven Development)指向のタスク管理プラグイン for Claude Code。
User Stories（親）と Tasks（子）をマークダウンで管理し、AIエージェントワークフローに最適化されたステータスフローを提供します。

## Features

- **Story/Task 階層管理**: User Story を親、Task を子として管理
- **AIエージェント対応**: タスクごとに Agent type + Model (opus/sonnet) を指定
- **SDD ステータスフロー**: BACKLOG → DEFINED → AI_READY → IN_PROGRESS → TESTING → REVIEW → DONE
- **マークダウンベース**: `.tasks/` ディレクトリにすべてのデータを保存。外部ツール不要
- **依存関係管理**: タスク間の Deps / Blocks を追跡
- **Teammate対応**: Team Manager が Agent + Model フィールドで自動ディスパッチ

## Visualizer

[cctd-web](https://github.com/esakat/cctd-web) でタスクの状態をビジュアルに確認できます。

## Install

### Plugin（推奨）

```
/plugin marketplace add esakat/cctd
/plugin install cctd@cctd
```

### Manual

```bash
# スキルファイルをプロジェクトにコピー
cp -r cctd/skills/* /path/to/your-project/.claude/skills/
```

## Usage

### コマンド

```
/cctd:list              # ストーリー/タスク一覧（フィルタ対応）
/cctd:view S001         # ストーリー詳細
/cctd:view S001-001     # タスク詳細
/cctd:spec              # 壁打ち → ストーリー → タスク分割 → SDD仕様
/cctd:spec S001         # 既存ストーリーのタスク分割 + 仕様策定
/cctd:spec S001-001     # 単一タスクのSpec記述/更新
/cctd:web               # Webビジュアライザ起動
/cctd:init              # .tasks/ ディレクトリ初期化
```

### ワークフロー

```
1. /cctd:init                    # プロジェクト初期化
2. /cctd:spec 認証システム作りたい  # 壁打ちからスタート
   → Phase 1: ソクラテス対話で要件発見
   → Phase 2: ユーザーストーリー作成
   → Phase 3: タスク分割 (Agent + Model 割当)
   → Phase 4: SDD仕様記述 (Claude自律 / Teammate並列)
3. /cctd:list                    # 進捗確認
4. /cctd:web                     # ブラウザで可視化
```

### 自律動作

Claude は CLAUDE.md のルールに従い、`.tasks/` のファイルを直接編集してタスクを管理します。
スラッシュコマンドはユーザーの状況確認用で、タスクの作成・編集・ステータス更新は Claude が自律的に行います。

## Model Selection

タスクごとに使用モデルを指定できます。Teammate dispatch 時にモデルが自動適用されます。

| Model | 用途 | 例 |
|---|---|---|
| `opus` (default) | 複雑な設計、アーキテクチャ、セキュリティ | API設計, DB設計, 認証実装 |
| `sonnet` | シンプル、定型、単一ファイル | 設定ファイル, 型定義, ボイラープレート |

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

## Plugin Structure

```
cctd/                              # Plugin directory
├── .claude-plugin/
│   └── plugin.json                # Plugin manifest
└── skills/
    ├── _shared/
    │   ├── format.md              # File format specification
    │   └── workflow.md            # Team Manager workflow rules
    ├── init/
    │   ├── SKILL.md               # /cctd:init
    │   └── scripts/init-tasks.sh
    ├── list/SKILL.md              # /cctd:list
    ├── view/SKILL.md              # /cctd:view
    ├── spec/SKILL.md              # /cctd:spec
    └── web/SKILL.md               # /cctd:web
```

## CLAUDE.md Integration

プロジェクトの `CLAUDE.md` に以下を追加:

```markdown
## CCTD
SDD指向のタスク管理。データは `.tasks/` に保存。
- コマンド: /cctd:list, /cctd:view, /cctd:spec, /cctd:web, /cctd:init
- フォーマット仕様: .claude/skills/_shared/format.md
- ワークフロー: .claude/skills/_shared/workflow.md
- タスクの作成・編集・ステータス更新はClaude自身がファイルを直接編集して行う。
```

## License

MIT
