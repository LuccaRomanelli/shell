#!/bin/bash
if [ -z "$1" ]; then
  echo "Usage: workdayadd <item>"
  exit 1
fi
export WORKDAY_ITEM="$*"
nvim --headless -c "lua require('workday').add_to_inbox(vim.env.WORKDAY_ITEM)" -c "quit"
