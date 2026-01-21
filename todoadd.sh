#!/bin/bash
if [ -z "$1" ]; then
  echo "Usage: todoadd <tarefa>"
  exit 1
fi

task="$*"
nvim -c "lua require('todo').add_task('$task')" -c "quit"
