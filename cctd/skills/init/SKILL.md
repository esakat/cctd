---
name: cctd:init
description: "Initialize .tasks/ directory for CCTD task management. Run once at the start of a project to set up the directory structure."
---

# CCTD Init

Set up the `.tasks/` directory structure for this project.

Run: `bash {SKILL_DIR}/scripts/init-tasks.sh`

Display the result. If already initialized, inform the user.

## Post-Init Guide

After successful initialization, display:

```
✅ .tasks/ ディレクトリを初期化しました。

📖 CCTD クイックスタート:
  1. /cctd:spec          要件発見 → ストーリー → タスク分割 → SDD仕様書
  2. /cctd:start S001    ストーリーの作業を開始（標準Tasks連携）
  3. /cctd:list           ストーリー/タスク一覧
  4. /cctd:view S001      ストーリーまたはタスクの詳細表示
  5. /cctd:web            Webビジュアライザ起動

💡 「S001の作業して」のように自然言語でも作業開始できます。
```
