# Shell Scripts

Shell scripts for automating Hyprland workspace management, development environments, and daily productivity.

## Scripts

### Workspace & Environment

| Script | Description |
|---|---|
| `start.sh` | Launches productivity apps across Hyprland workspaces: Abacus AI chat, YouTube, browser, WhatsApp, ClickUp, and Google Sheets |
| `yopki.sh` | Sets up the Yopki dev environment: nvim for frontend (ws 3) and backend (ws 4), Docker + dev servers (ws 5) |
| `theme_swap_random.sh` | Randomly picks and applies a theme from `~/.config/omarchy/themes/` |

### Productivity

| Script | Description |
|---|---|
| `pomo.sh` | Pomodoro timer with classic (25/5) and deep (50/10) modes, session logging to JSON, Obsidian markdown integration, Waybar status, and weekly stats via `fzf` menus |
| `todo.sh` | Opens a todo list in nvim. Usage: `todo.sh [personal\|work\|vanta]` |
| `todoadd.sh` | Adds a task to a todo list from the CLI. Usage: `todoadd [work\|vanta] <task>` |
| `zet.sh` | Creates a Zettelkasten note and opens it in nvim. Usage: `zet <title>` |
| `ask.sh` | Quick CLI question to Claude (haiku model). Usage: `? <question>` |

### Documents & Email

| Script | Description |
|---|---|
| `md2pdf.sh` | Converts Markdown to PDF using pandoc + xelatex |
| `mail_file.sh` | Sends files as email attachments (supports mutt, mailx, sendmail) |
| `md2pdf_mail.sh` | Converts Markdown files to PDF and emails them. Supports batch processing |

## Dependencies

- **Hyprland** + `hyprctl` — tiling Wayland compositor
- **omarchy** commands — `omarchy-launch-webapp`, `omarchy-launch-or-focus-webapp`, `omarchy-launch-browser`, `omarchy-theme-set`
- **uwsm** — user-level session manager (terminal launching)
- **pandoc** + **xelatex** (`texlive`) — Markdown to PDF conversion
- **jq** — JSON processing (used by `pomo.sh`)
- **fzf** — fuzzy finder (used by `pomo.sh`)
- **Docker** — container management (used by `yopki.sh`)
- **nvim** — Neovim with custom Lua modules (`todo`, `zet`)
- **claude** CLI — Anthropic's Claude Code (used by `ask.sh`)
- **notify-send** — desktop notifications (used by `pomo.sh`)
- Mail tools: **mutt**, **mailx**, or **sendmail** (used by `mail_file.sh`)

## Usage Examples

```bash
# Launch all productivity apps
./start.sh

# Random theme switch
./theme_swap_random.sh

# Convert and email a document
./md2pdf_mail.sh notes.md "Meeting Notes" user@email.com

# Quick AI question
./ask.sh "What is the capital of France?"

# Create a Zettelkasten note
./zet.sh "Project Ideas"

# Start a pomodoro session
./pomo.sh
```

## Using Individual Scripts

To use a single script without cloning the entire repo:

```bash
# Download a specific script
curl -O https://raw.githubusercontent.com/<user>/shell/main/<script>.sh
chmod +x <script>.sh
```

Or clone only what you need with a sparse checkout:

```bash
git clone --no-checkout https://github.com/<user>/shell.git
cd shell
git sparse-checkout init --cone
git sparse-checkout set pomo.sh todo.sh  # pick the scripts you want
git checkout
```
