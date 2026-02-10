タスクの詳細を表示する。
表示したら終了。操作メニューやAskUserQuestionは出さない。

$ARGUMENTS にタスクIDが指定されている場合はそれを使用。
指定がない場合は「IDを指定してください（例: /task-view 003）」と返す。

手順:
1. .tasks/tasks/{ID}.md を読み込む
2. 以下のフォーマットで見やすく表示:

```
┌─────────────────────────────────────────────┐
│ 📌 TASK-{ID}                                │
│ {Title}                                      │
├─────────────────────────────────────────────┤
│ Status:    {emoji} {Status}                  │
│ Priority:  {Priority}                        │
│ Labels:    {Labels}                          │
│ Created:   {Date}                            │
│ Blocks:    {依存先 or なし}                   │
│ Blocked-by:{依存元 or なし}                   │
└─────────────────────────────────────────────┘

## Description
{description内容}

## Work Log
{作業記録を時系列で表示}
```

Work Log の各エントリは以下の形式で表示:
**[日付]** 記録内容
- 変更ファイル、実行コマンド、判断、結果などがあればインデントで補足

表示の最後に薄くコマンドヒント:
`/task-edit {ID}` `/task-done {ID}` `/tasks`
