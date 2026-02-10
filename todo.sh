#!/bin/bash
TYPE="personal"
while getopts "wv" opt; do
  case $opt in
    w) TYPE="work" ;;
    v) TYPE="vanta" ;;
  esac
done
nvim -c "lua require('todo').open_todo('$TYPE')"
