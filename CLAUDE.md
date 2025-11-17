# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Purpose

This repository contains shell scripts for automating Hyprland workspace management and application launching. The scripts use `hyprctl` (Hyprland control) commands to orchestrate workspace navigation and application launching across multiple virtual desktops.

## Architecture

### Workspace-Based Organization

Scripts follow a pattern of workspace-based application organization:
- Workspace 1: General productivity (Abacus AI chat)
- Workspace 2: Browser
- Workspaces 3-4: Development environments (nvim editors)
- Workspace 5: Development servers and build processes
- Workspace 6: Communication (WhatsApp, ClickUp, Google Chat)
- Workspace 7: Project management (Jira, ClickUp, Google Sheets)
- Workspace 8: Personal productivity (Todoist, Google Calendar)
- Workspace 9: Entertainment (YouTube Music)

### Custom Commands

The scripts depend on custom `omarchy-*` commands which are external to this repository:
- `omarchy-launch-webapp`: Launches web applications in dedicated windows
- `omarchy-launch-or-focus-webapp`: Launches or focuses existing webapp instances
- `omarchy-launch-browser`: Launches the browser
- `omarchy-theme-*`: Various theme management commands
- `omarchy-restart-*`: Component restart commands
- `omarchy-hook`: Hook system for custom actions

### Script Files

- **start.sh**: Main startup script that launches productivity and communication applications across workspaces 1, 2, 6, 7, 8, and 9
- **onhappy.sh**: Development environment setup for the "onhappy" project (frontend/backend on workspaces 3-5)
- **yopki.sh**: Development environment setup for the "yopki" project (trip-planner-web/backend on workspaces 3-5)
- **close.sh**: Utility to close all windows across all workspaces using `hyprctl` and `jq`
- **theme_swap_random.sh**: Randomly selects and applies themes from `~/.config/omarchy/themes/`

## Key Development Patterns

### Timing and Synchronization

Scripts use `sleep` delays between operations to ensure applications have time to launch before proceeding. This is critical for stability:
- Short delays (0.5-0.8s) for workspace switches and light operations
- Medium delays (1.0-1.2s) for application launches

### Development Environment Setup

The onhappy.sh and yopki.sh scripts follow this pattern:
1. Switch to workspace 3, launch nvim for frontend
2. Switch to workspace 4, launch nvim for backend
3. Switch to workspace 5, start Docker containers and development servers
4. Use `uwsm app -- "$TERMINAL"` to launch terminal sessions
5. Chain commands with `; exec zsh` to keep terminals open

### Docker Management

Development scripts include Docker cleanup before starting:
```bash
docker ps -q | xargs -r docker stop  # Stop all containers
docker start $(docker ps -aq -f "name=^<prefix>-")  # Start project-specific containers
```

## Modifying Scripts

When editing these scripts:

- Maintain consistent `sleep` timing between operations
- Preserve the workspace navigation sequence (using `hyprctl dispatch workspace N`)
- Use absolute paths when referencing project directories
- Background processes that don't block use `&` suffix
- Terminal commands use `uwsm app -- "$TERMINAL" -e zsh -c '<command>; exec zsh'` pattern
- The theme system expects themes in `~/.config/omarchy/themes/` and uses symlinks to `~/.config/omarchy/current/theme`
