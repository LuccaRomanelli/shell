#!/bin/bash
if [ -z "$*" ]; then
  echo "Usage: ??? <question>"
  exit 1
fi

start_time=$(date +%s.%N)
cd ~ && claude -p --model haiku --setting-sources user --no-session-persistence "$*"
elapsed=$(awk "BEGIN {printf \"%.1f\", $(date +%s.%N) - $start_time}")
printf "\n⏱ %ss\n" "$elapsed"
