# Shell Scripts Collection

A collection of shell scripts for Hyprland workspace management, productivity automation, and document processing.

## Scripts

### Workspace & Desktop

| Script | Description |
|--------|-------------|
| `start.sh` | Launches productivity apps across Hyprland workspaces (browser, chat apps, project management tools) |
| `theme_swap_random.sh` | Randomly selects and applies a theme from `~/.config/omarchy/themes/` |

### Productivity (Neovim Integration)

| Script | Description |
|--------|-------------|
| `todo.sh` | Opens the todo list in Neovim using the `todo` Lua module |
| `todoadd.sh <task>` | Adds a task to the todo list via Neovim |
| `zet.sh <title>` | Creates a new Zettelkasten note via Neovim |

### Document Processing

| Script | Description |
|--------|-------------|
| `md2pdf.sh <file.md> [output.pdf]` | Converts Markdown to PDF using pandoc with xelatex |
| `mail_file.sh <file> [subject] [recipient]` | Sends a file as an email attachment |
| `md2pdf_mail.sh <file.md> [subject] [recipient]` | Converts Markdown to PDF and sends it via email |

### AI Assistant

| Script | Description |
|--------|-------------|
| `ask.sh <question>` | Quick AI question using Claude CLI (haiku model) |

## Dependencies

- **Hyprland** - Wayland compositor (for workspace scripts)
- **omarchy-\*** commands - Custom Hyprland automation tools
- **pandoc** + **xelatex** - Document conversion
- **mutt/mailx/sendmail** - Email sending
- **Neovim** - Editor with custom Lua modules (`todo`, `zet`)
- **Claude CLI** - AI assistant

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
```

## License

Personal use scripts - no license specified.
