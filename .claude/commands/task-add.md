新しいタスクを .tasks/ に追加する。AskUserQuestionは使わない。

$ARGUMENTS をパースしてタスク情報を取得する。
フォーマット: /task-add {タイトル}
オプション: --priority={high|medium|low} --labels={ラベル} --desc={説明}

デフォルト: priority=medium, labels=なし, desc=TBD

$ARGUMENTS が空の場合は使い方を表示:
```
使い方: /task-add タスクタイトル [--priority=high] [--labels=dev,web] [--desc=説明文]
```

手順:
1. .tasks/index.md を読み、現在の最大IDを確認する
2. 新しいID = 最大ID + 1（ゼロ埋め3桁）
3. .tasks/index.md に行を追加: {ID}|TODO|{Title}|{Labels}|{Priority}|{今日の日付}
4. .tasks/tasks/{ID}.md を作成:

```markdown
# {Title}
- ID: {ID}
- Status: TODO
- Labels: {Labels}
- Priority: {Priority}
- Created: {今日の日付}
- Blocked-by: -
- Blocks: -

## Description
{desc の値、なければ TBD}

## Work Log
[{今日の日付}] タスク作成
```

5. 作成完了を1行で表示: ✅ TASK-{ID} `{Title}` を作成しました
