#!/bin/bash
TYPE="personal"
while getopts "wv" opt; do
  case $opt in
    w) TYPE="work" ;;
    v) TYPE="vanta" ;;
  esac
done
shift $((OPTIND - 1))

if [ -z "$1" ]; then
  echo "Usage: todoadd [-w|-v] <tarefa>"
  exit 1
fi

task="$*"
nvim -c "lua require('todo').add_task('$task', '$TYPE')" -c "quit"
