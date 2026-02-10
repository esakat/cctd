.tasks/index.md を読み込み、タスク一覧をMarkdownテーブルで表示せよ。
表示したら終了。操作メニューやAskUserQuestionは出さない。ユーザーが自分で次の指示を出す。

表示フォーマット:
```
📋 タスク一覧 (完了数/全体数)

| ID  | Status | Title | Labels | Priority |
|-----|--------|-------|--------|----------|
```

Status表示ルール:
- TODO → 🔴 TODO
- WIP → 🟡 WIP
- DONE → 🟢 DONE

$ARGUMENTS が空でなければフィルタとして適用:
- "todo", "wip", "done" → そのステータスのみ表示
- "high", "medium", "low" → そのpriorityのみ表示
- その他の文字列 → ラベルに含まれるもののみ表示
- 複数フィルタはスペース区切りで AND 条件

テーブルの下に使えるコマンドのヒントを1行で小さく出す:
`/task-view {ID}` `/task-add` `/task-done {ID}` `/task-edit {ID}` `/tasks {filter}`
