#!/bin/bash

THEMES_DIR="$HOME/.config/omarchy/themes/"
CURRENT_THEME_DIR="$HOME/.config/omarchy/current/theme"
themes=($(ls -d $THEMES_DIR/*/ 2>/dev/null | xargs -n 1 basename))

if [ ${#themes[@]} -eq 0 ]; then
  echo "$(date): Nenhum tema encontrado em $THEMES_DIR" 
  exit
fi

THEME_NAME=${themes[$RANDOM % ${#themes[@]}]}
echo "Swaping for theme: $THEME_NAME" 
THEME_PATH="$THEMES_DIR/$THEME_NAME"

# Check if the theme entered exists
if [[ ! -d "$THEME_PATH" ]]; then
  echo "Theme '$THEME_NAME' does not exist in $THEMES_DIR"
  exit 1
fi

# Update theme symlinks
ln -nsf "$THEME_PATH" "$CURRENT_THEME_DIR"

# Change background with theme
omarchy-theme-bg-next

# Restart components to apply new theme
if pgrep -x waybar >/dev/null; then
  omarchy-restart-waybar
fi
omarchy-restart-swayosd
hyprctl reload
pkill -SIGUSR2 btop
makoctl reload

# Change gnome, browser, vscode, cursor themes
omarchy-theme-set-gnome
omarchy-theme-set-browser
omarchy-theme-set-vscode
omarchy-theme-set-obsidian

# Call hook on theme set
omarchy-hook theme-set "$THEME_NAME"
