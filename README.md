# Setup Ishan's Development Environment

This repository contains scripts and configurations to quickly set up a new macOS or Linux (Ubuntu) development environment.

## macOS Setup

### 1. Manual Initial Setup (Applications & System Settings)

These steps are typically done once when setting up a new Mac:

1.  Install Chrome/Arc browser.
2.  Download and install Raycast. Configure it to replace Spotlight (e.g., map to `Cmd+Space`).
3.  In System Settings > Keyboard, set "Key repeat rate" to Fast and "Delay until repeat" to Short.
4.  To disable the press-and-hold accent character menu and enable key repeat for all keys, run:
    ```bash
    defaults write -g ApplePressAndHoldEnabled -bool false
    ```
    (A restart might be required for this to take full effect everywhere).
5.  Install iTerm2.
6.  Install Rectangle (window manager).
7.  Install Cursor (editor).
    - You can find editor settings (e.g., `settings.json` for VS Code/Cursor) in this repository, which you can manually copy or symlink.
8.  In System Settings > Trackpad, set tracking speed to Fast.

### 2. Automated Shell and Tool Setup (Scripts)

Run these commands in your terminal:

**A. Setup Zsh (Shell Environment)**

This will install your Zsh configuration (`.zshrc`), which includes common aliases and functions.

```bash
curl -sSL https://raw.githubusercontent.com/ishandhanani/setup/main/generated_dotfiles/.zshrc -o ~/.zshrc && echo "Zsh configuration installed. Please source it (source ~/.zshrc) or open a new terminal."
```

_Note: This directly installs the generated `.zshrc`. If you maintain a separate `setup-zsh.sh` script, ensure it correctly installs the generated Zsh configuration._

**B. Setup Vim**

This will install your Vim configuration (`.vimrc`), the Jellybeans theme, and vim-plug plugin manager.

```bash
curl -sSL https://raw.githubusercontent.com/ishandhanani/setup/main/linux/vim_setup.sh | bash
```

After this, open Vim and run `:PlugInstall` to install plugins.
_(Note: `linux/vim_setup.sh` is used as it's now generic for Vim setup on both platforms)._

**C. Install Command-Line Tools**

This installs common command-line tools like `bat`, `uv`, etc., as defined in `tool-manifest.yaml`.

```bash
curl -sSL https://raw.githubusercontent.com/ishandhanani/setup/main/darwin/setup-tools.sh | bash
```

## Linux (Ubuntu) Setup

For a new Linux (Ubuntu) development box or container, a single command sets up your Bash environment, Vim, and common command-line tools:

```bash
curl -sSL https://raw.githubusercontent.com/ishandhanani/setup/main/linux/install.sh | bash
```

This script will:

- Install your Bash configuration (`.bashrc`).
- Set up Vim (including theme, plugins via vim-plug - run `:PlugInstall` in Vim afterwards).
- Install tools defined in `tool-manifest.yaml` (e.g., `bat`, `uv`).

## Dotfile and Tool Management

This repository uses a structured approach to manage configurations:

- **`shared/common_shell_config.sh`**: Contains aliases, functions, and exports common to both Bash and Zsh.
- **`shared/common_vimrc`**: Contains the main Vim configuration.
- **`.zshrc` (root file)**: Contains Zsh-specific configurations for macOS.
- **`tool-manifest.yaml`**: A YAML file defining tools to be installed, their check commands, and install commands for macOS and Linux. The setup scripts parse this to install tools.
- **`scripts/generate_dotfiles.sh`**: A script that combines the shared and specific configurations to produce final `.bashrc`, `.zshrc`, and `.vimrc` files in the `generated_dotfiles/` directory.
- **`generated_dotfiles/`**: This directory contains the final, complete dotfiles. The setup scripts download these pre-generated files.

### Automated Dotfile Generation

A GitHub Action is configured in `.github/workflows/generate_dotfiles.yml` to:

1.  Run `scripts/generate_dotfiles.sh` daily.
2.  Run it on pushes to `main` if relevant configuration files (`shared/*`, `.zshrc`, `scripts/generate_dotfiles.sh`) change.
3.  Commit and push any changes to the `generated_dotfiles/` directory back to the repository.

This ensures the dotfiles in `generated_dotfiles/` are always up-to-date with the modular configurations.

## Adding New Tools

1.  Edit `tool-manifest.yaml`.
2.  Add a new entry for your tool, specifying:
    - `name`
    - `description`
    - `macos.enabled` (true/false)
    - `macos.check_command` (e.g., `command -v newtool`)
    - `macos.install_command` (e.g., `brew install newtool`)
    - `linux.enabled` (true/false)
    - `linux.check_command`
    - `linux.install_command` (e.g., `sudo apt install -y newtool`)
3.  The setup scripts will automatically pick up the new tool.

## Shell Configuration Notes

- **Bash (Linux)**: The `.bashrc` is constructed from `shared/common_shell_config.sh` and Bash-specific PS1 settings.
- **Zsh (macOS)**: The `.zshrc` is constructed from the root `.zshrc` file (containing Zsh specifics) and `shared/common_shell_config.sh`.

Your `settings.json` and `iterm2state.itermexport` files are still in the repository and can be manually applied or symlinked as needed.
