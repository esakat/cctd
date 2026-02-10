# CCTD - Claude Code Task Dashboard

## タスク管理
SDD指向のタスク管理。ストーリー(親) → タスク(子)をMarkdownで管理。データは `.tasks/` に保存。

### コマンド
- `/cctd:list` - ストーリー/タスク一覧
- `/cctd:view {ID}` - 詳細表示
- `/cctd:spec` - 要件発見→ストーリー→タスク分割→SDD仕様
- `/cctd:web` - Webビジュアライザ起動
- `/cctd:init` - .tasks/ 初期化

### 自律動作ルール
タスクの作成・編集・ステータス更新はClaude自身が `.tasks/` のファイルを直接編集して行う。
- フォーマット仕様: `cctd/skills/_shared/format.md`
- チームワークフロー: `cctd/skills/_shared/workflow.md`

### ファイル構造
- `.tasks/index.md` - インデックス（パイプ区切り）
- `.tasks/stories/{ID}.md` - ストーリー詳細
- `.tasks/tasks/{ID}.md` - タスク詳細
