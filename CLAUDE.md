# CCTD - Claude Code Task Dashboard

## タスク管理システム
プロジェクト内蔵のタスク管理。外部ツール不要。

### コマンド
- `/tasks` - タスク一覧表示（フィルタ対応）
- `/task-add` - 新規タスク追加
- `/task-done` - タスク完了
- `/task-view` - タスク詳細表示
- `/task-edit` - タスク編集

### ファイル構造
- `.tasks/index.md` - タスクインデックス（パイプ区切り、軽量）
- `.tasks/tasks/{ID}.md` - タスク詳細ファイル
