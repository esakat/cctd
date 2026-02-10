# Command: Status / Done

## Status
`/cctd status {ID} {STATUS}`

Update in both file and index. Append to Work Log: `[{date}] Status → {STATUS}`

Auto-update story status:
- Any child → IN_PROGRESS: story → IN_PROGRESS
- All children → DONE: story → DONE

## Done
`/cctd done {ID}` — shortcut for `status {ID} DONE`.

If task had Blocks, mention newly unblocked tasks.
Display: `✅ {ID} \`{title}\` → DONE`
