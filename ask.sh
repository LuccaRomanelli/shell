#!/bin/bash
if [ -z "$*" ]; then
  echo "Usage: ? <question>"
  exit 1
fi

claude -p --model haiku "$*"
