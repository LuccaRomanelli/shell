#!/bin/bash
# Query Claude Sonnet from the command line

if [ -z "$*" ]; then
  echo "Usage: ask <question>"
  exit 1
fi

claude -p --model haiku --tools "" --system-prompt "Answer concisely." "$*"
