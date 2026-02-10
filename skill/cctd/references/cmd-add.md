# Command: Add

## Add Story (no S-prefix in args)
`/cctd add {title} [--labels=a,b] [--priority=high]`

Defaults: priority=medium, labels=none

1. Read index, find max S-number, new ID = max+1
2. Create `.tasks/stories/{ID}.md` (see format.md Story template)
3. Append to index Stories section
4. Display: `✅ {ID} \`{title}\` を作成 (BACKLOG)`

## Add Task (first arg starts with S)
`/cctd add {StoryID} {title} --agent={subagent_type} [--priority=high] [--deps=S001-001]`

Agent is required. Defaults: priority=medium, deps=none

1. Verify story exists
2. Find max task number under that story, new ID = {StoryID}-{max+1}
3. Create `.tasks/tasks/{ID}.md` (see format.md Task template)
4. Append to index Tasks section
5. If story BACKLOG → auto-promote to DEFINED
6. Display: `✅ {ID} \`{title}\` を作成 (agent: {agent})`

No args → show usage.
