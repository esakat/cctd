#!/bin/bash
# CCTD - Initialize .tasks/ directory in current project

TASKS_DIR=".tasks"

if [ -d "$TASKS_DIR" ]; then
  echo "⚠️  .tasks/ already exists. Skipping initialization."
  exit 0
fi

mkdir -p "$TASKS_DIR/stories" "$TASKS_DIR/tasks"

cat > "$TASKS_DIR/index.md" << 'EOF'
# Stories
# ID|Status|Title|Labels|Priority|Created

# Tasks
# ID|Status|Title|Agent|Deps|Created
EOF

echo "✅ .tasks/ initialized. Use /cctd add to create your first story."
