# Command: Edit

`/cctd edit {ID} {natural language instruction}`

Examples:
- `/cctd edit S001 ACに「2FA対応」追加`
- `/cctd edit S001-001 Specにエンドポイント仕様記載`
- `/cctd edit S001-002 agentをgeneral-purposeに変更`
- `/cctd edit S001-001 depsにS001-003追加`

1. Read story/task file
2. Apply edit as instructed
3. Sync index if Title/Labels/Priority/Status/Agent changed
4. Append Work Log: `[{date}] {change summary}`
5. Display 1-line confirmation

No args → show usage.
