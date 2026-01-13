#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: zet <title>"
  exit 1
fi

# Join all arguments and convert spaces to underscores for the title
title="${*// /_}"

# Call Lua directly and open the created file
nvim -c "lua local f = require('zet').create_note('$title'); if f then vim.cmd('edit ' .. vim.fn.fnameescape(f)) end"
