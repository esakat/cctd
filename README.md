# CCTD - Claude Code Task Dashboard

SDD(Spec-Driven Development)指向のタスク管理プラグイン for Claude Code。

「認証システム作りたい」のような抽象的な指示から、ソクラテス対話で要件を掘り下げ、User Story → Task 分割 → SDD仕様策定までを Claude が自律的に進行します。ユーザーは壁打ちとレビューに集中し、タスクの作成・編集・ステータス管理はすべて Claude が行います。

## 設計思想

**ユーザーがやること:**
- 抽象的な指示を出す（「認証システム作りたい」）
- `/cctd:spec` で壁打ちしながら要件を固める
- `/cctd:list` `/cctd:view` で進捗を俯瞰する

**Claudeが自律的にやること:**
- ストーリー作成・タスク分割
- SDD仕様（Spec）の記述
- ステータス更新・依存関係管理
- Teammate への作業ディスパッチ（Agent + Model 指定）

スラッシュコマンドはユーザーの状況確認と対話用に最小限。タスク操作は Claude が `.tasks/` のマークダウンファイルを直接編集して行います。

## Features

- **Story/Task 階層管理** — User Story（親）と Task（子）で構造化
- **SDD ステータスフロー** — BACKLOG → DEFINED → AI_READY → IN_PROGRESS → TESTING → REVIEW → DONE
- **壁打ち → 仕様策定** — `/cctd:spec` でソクラテス対話から SDD Spec まで一気通貫
- **Teammate 対応** — タスクごとに Agent type + Model (opus/sonnet) を指定し、Team Manager が自動ディスパッチ
- **マークダウンベース** — `.tasks/` ディレクトリにすべてのデータを保存。外部ツール不要
- **依存関係管理** — タスク間の Deps / Blocks を追跡し、完了時に自動解決

## Install

### Plugin（推奨）

```
/plugin marketplace add esakat/cctd
/plugin install cctd@cctd
```

### Manual

```bash
cp -r cctd/skills/* /path/to/your-project/.claude/skills/
```

## Commands

| コマンド | 用途 | ユーザー操作 |
|---|---|---|
| `/cctd:spec` | 壁打ち → ストーリー → タスク分割 → SDD仕様 | 対話型 |
| `/cctd:list` | ストーリー/タスク一覧（フィルタ対応） | 表示のみ |
| `/cctd:view {ID}` | ストーリーまたはタスクの詳細表示 | 表示のみ |
| `/cctd:web` | cctd-web ビジュアライザをバックグラウンド起動 | 起動のみ |
| `/cctd:init` | `.tasks/` ディレクトリの初期化 | 初回のみ |

## Workflow

### 1. 初期化

```
/cctd:init
```

### 2. 壁打ちから仕様策定まで

```
/cctd:spec 認証システム作りたい
```

`/cctd:spec` は入力に応じて自動ルーティングします:

| 入力 | 開始フェーズ |
|---|---|
| テキスト or 空 | Phase 1 から（フル対話フロー） |
| `S001` (Story ID) | Phase 3 から（タスク分割 + 仕様策定） |
| `S001-001` (Task ID) | Phase 4 のみ（単一タスクの Spec 記述） |

**Phase 1: Discovery（同期 — ユーザー対話）**
ソクラテス対話で要件を掘り下げる。スコープ、ユーザー像、制約を明確化。

**Phase 2: Story 作成（同期 — ユーザー承認）**
User Story + Acceptance Criteria を作成。ユーザーが承認後にファイル生成。

**Phase 3: Task 分割（半同期 — ユーザー承認）**
実装タスクに分割。各タスクに Agent type・Model・依存関係を割り当て。分割案をユーザーに提示し、承認後に作成。

**Phase 4: SDD Spec 記述（非同期 — Claude 自律）**
各タスクの Spec セクションを Claude が自律的に記述。複数の実装アプローチがあり得る箇所のみユーザーに確認。Teammate による並列実行が可能。

### 3. 進捗確認

```
/cctd:list              # 全体俯瞰
/cctd:list in_progress  # フィルタ: 進行中のみ
/cctd:view S001         # ストーリー詳細 + 子タスク一覧
/cctd:view S001-001     # タスク詳細 + Spec
/cctd:web               # ブラウザで可視化
```

### 4. 実装（Team Manager 自律動作）

AI_READY になったタスクは Team Manager が自動的に Teammate へディスパッチします:

```
Team Manager
├── .tasks/index.md を読んで AI_READY タスクを検出
├── タスクの Agent + Model フィールドで Teammate を spawn
│   ├── S001-001: backend-architect (opus)
│   ├── S001-002: frontend-architect (sonnet)
│   └── S001-003: quality-engineer (opus)
├── 依存関係に基づいて実行順序を制御
└── 完了時にステータス更新 + 依存解消
```

詳細は `cctd/skills/_shared/workflow.md` を参照。

## Model Selection

タスクごとに Teammate の使用モデルを指定します。

| Model | 用途 | 例 |
|---|---|---|
| `opus` (default) | 複雑な設計、アーキテクチャ、マルチファイル、セキュリティ | API設計, DB設計, 認証実装 |
| `sonnet` | シンプル、定型、単一ファイル、ボイラープレート | 設定ファイル, 型定義, テストデータ |

`/cctd:spec` の Phase 3 でタスク分割時に、複雑さに応じて自動的に Model を割り当てます。

## Status Flow

### Stories
```
BACKLOG ⚪ → DEFINED 🔵 → IN_PROGRESS 🟡 → DONE 🟢
```
- DEFINED: ユーザーと要件が合意済み
- IN_PROGRESS: 子タスクのいずれかが着手
- DONE: 全子タスクが完了

### Tasks
```
BACKLOG ⚪ → DEFINED 🔵 → AI_READY 🟣 → IN_PROGRESS 🟡 → TESTING 🟠 → REVIEW 🔶 → DONE 🟢
```
- AI_READY: Spec 完了、Agent 割当済、依存解消済 → Teammate にディスパッチ可能
- TESTING: 実装完了、QA エージェントが検証中
- REVIEW: テスト通過、ユーザーレビュー待ち

## Data Structure

### .tasks/ ディレクトリ
```
.tasks/
├── index.md          # パイプ区切りインデックス
├── stories/
│   └── S001.md       # Story: User Story + AC
└── tasks/
    └── S001-001.md   # Task: Spec + Work Log
```

### index.md フォーマット
```
# Stories
# ID|Status|Title|Labels|Priority|Created
S001|DEFINED|ユーザー認証の実装|auth,backend|high|2026-02-10

# Tasks
# ID|Status|Title|Agent|Model|Deps|Created
S001-001|AI_READY|認証API設計|backend-architect|opus|-|2026-02-10
S001-002|BACKLOG|ログインUI|frontend-architect|sonnet|S001-001|2026-02-10
```

詳細は `cctd/skills/_shared/format.md` を参照。

## Plugin Structure

```
cctd/                                # Repository root
├── .claude-plugin/
│   └── marketplace.json             # Marketplace catalog
├── cctd/                            # Plugin directory
│   ├── .claude-plugin/
│   │   └── plugin.json              # Plugin manifest
│   └── skills/
│       ├── _shared/
│       │   ├── format.md            # ファイルフォーマット仕様
│       │   └── workflow.md          # Team Manager ワークフロー
│       ├── init/
│       │   ├── SKILL.md             # /cctd:init
│       │   └── scripts/init-tasks.sh
│       ├── list/SKILL.md            # /cctd:list
│       ├── view/SKILL.md            # /cctd:view
│       ├── spec/SKILL.md            # /cctd:spec
│       └── web/SKILL.md             # /cctd:web
├── .tasks/                          # テンプレート（空）
├── CLAUDE.md
└── README.md
```

## CLAUDE.md Integration

プロジェクトの `CLAUDE.md` に以下を追加すると、Claude がタスク管理を自律的に行います:

```markdown
## CCTD
SDD指向のタスク管理。データは `.tasks/` に保存。
- コマンド: /cctd:list, /cctd:view, /cctd:spec, /cctd:web, /cctd:init
- フォーマット仕様: .claude/skills/_shared/format.md
- ワークフロー: .claude/skills/_shared/workflow.md
- タスクの作成・編集・ステータス更新はClaude自身がファイルを直接編集して行う。
```

## Visualizer

[cctd-web](https://github.com/esakat/cctd-web) でストーリーとタスクの状態をブラウザで確認できます。

```
/cctd:web
```

## License

MIT
