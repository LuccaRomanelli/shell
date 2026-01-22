#!/bin/bash

# Get list of available themes
themes=($(omarchy-theme-list 2>/dev/null))

if [ ${#themes[@]} -eq 0 ]; then
  # Fallback to directory listing if omarchy-theme-list fails
  THEMES_DIR="$HOME/.config/omarchy/themes/"
  themes=($(ls -d $THEMES_DIR/*/ 2>/dev/null | xargs -n 1 basename))
fi

if [ ${#themes[@]} -eq 0 ]; then
  echo "No themes found"
  exit 1
fi

# Pick a random theme
THEME_NAME=${themes[$RANDOM % ${#themes[@]}]}
echo "Swapping to theme: $THEME_NAME"

# Use omarchy-theme-set for full theme application (same as META+ALT+BACKSPACE)
omarchy-theme-set "$THEME_NAME"
