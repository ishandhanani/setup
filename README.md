# Ishan's Development Environment Setup

Quickly set up a new macOS or Linux (Ubuntu) development environment with essential tools and configurations.

## Installation

### macOS

1.  **Manual App & System Setup (Optional - First time on a new Mac)**:

    - Install Chrome/Arc, Raycast, iTerm2, Rectangle, Cursor.
    - Adjust Keyboard/Trackpad speed settings.
    - Disable press-and-hold for accents: `defaults write -g ApplePressAndHoldEnabled -bool false` (restart might be needed).

2.  **Automated Shell, Vim & Tools Setup**:
    - **Zsh Shell**:
      ```bash
      curl -sSL https://raw.githubusercontent.com/ishandhanani/setup/dotfiles-latest/generated_dotfiles/.zshrc -o ~/.zshrc && echo "Zsh config installed. Source it or open a new terminal."
      ```
    - **Vim**:
      ```bash
      curl -sSL https://raw.githubusercontent.com/ishandhanani/setup/main/linux/vim_setup.sh | bash
      ```
      Then, open Vim and run `:PlugInstall`.
    - **Command-Line Tools** (from `tool-manifest.yaml`):
      ```bash
      curl -sSL https://raw.githubusercontent.com/ishandhanani/setup/main/darwin/setup-tools.sh | bash
      ```

### Linux (Ubuntu)

For a new Linux (Ubuntu) system, this single command sets up Bash, Vim, and command-line tools:

```bash
curl -sSL https://raw.githubusercontent.com/ishandhanani/setup/main/linux/install.sh | bash
```

After setup, open Vim and run `:PlugInstall`.

## Repository Structure

- **`tool-manifest.yaml`**: Defines tools to install (name, OS, check/install commands).
- **`common_rc/`**: Source files for dotfile components:
  - `common_shell_config.sh`: Aliases/exports for Bash & Zsh.
  - `bash_specifics.sh`: Bash-only settings (e.g., PS1).
  - `zsh_specifics.sh`: Zsh-only settings (e.g., PS1).
  - `common_vimrc`: Vim configuration.
- **`scripts/generate_dotfiles.sh`**: Combines files from `common_rc/` into final dotfiles.
- **`generated_dotfiles/`**: Contains the complete, auto-generated `.bashrc`, `.zshrc`, and `.vimrc` that are downloaded during setup.
- **`darwin/`**: macOS-specific setup scripts (e.g., `setup-tools.sh`).
- **`linux/`**: Linux-specific setup scripts (e.g., `install.sh`).
- **`.github/workflows/generate_dotfiles.yaml`**: GitHub Action to auto-generate and commit dotfiles in `generated_dotfiles/` daily and on relevant changes.

## Adding New Tools

1.  Edit `tool-manifest.yaml`.
2.  Add your tool with its `name`, `description`, and OS-specific `enabled`, `check_command`, and `install_command` fields.
3.  The setup scripts will automatically handle the new tool.

Your `settings.json` (for Cursor/VSCode) and `iterm2state.itermexport` are also in the repository for manual application.
