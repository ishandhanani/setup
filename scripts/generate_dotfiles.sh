#!/bin/bash

# Script to generate consolidated .bashrc and .zshrc files

set -e # Exit on error

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
REPO_ROOT="$SCRIPT_DIR/.."
CONFIG_SOURCE_DIR="$REPO_ROOT/common_rc" # New source directory

COMMON_CONFIG_PATH="$CONFIG_SOURCE_DIR/common_shell_config.sh"
ZSH_SPECIFIC_CONFIG_PATH="$CONFIG_SOURCE_DIR/zsh_specifics.sh" # Updated path
BASH_SPECIFIC_CONFIG_PATH="$CONFIG_SOURCE_DIR/bash_specifics.sh" 
COMMON_VIMRC_PATH="$CONFIG_SOURCE_DIR/common_vimrc"
GENERATED_DIR="$REPO_ROOT/generated_dotfiles"

# Ensure common_shell_config.sh exists
if [ ! -f "$COMMON_CONFIG_PATH" ]; then
    echo "Error: Common shell config not found at $COMMON_CONFIG_PATH" >&2
    exit 1
fi

# Ensure zsh_specifics.sh exists
if [ ! -f "$ZSH_SPECIFIC_CONFIG_PATH" ]; then
    echo "Error: Zsh specific config not found at $ZSH_SPECIFIC_CONFIG_PATH" >&2
    exit 1
fi

# Ensure bash_specifics.sh exists
if [ ! -f "$BASH_SPECIFIC_CONFIG_PATH" ]; then
    echo "Error: Bash specific config not found at $BASH_SPECIFIC_CONFIG_PATH" >&2
    exit 1
fi

# Ensure common_vimrc exists
if [ ! -f "$COMMON_VIMRC_PATH" ]; then
    echo "Error: Common vimrc not found at $COMMON_VIMRC_PATH" >&2
    exit 1
fi

COMMON_CONFIG_CONTENT=$(cat "$COMMON_CONFIG_PATH")
ZSH_SPECIFIC_CONTENT=$(cat "$ZSH_SPECIFIC_CONFIG_PATH")
BASH_SPECIFIC_CONTENT=$(cat "$BASH_SPECIFIC_CONFIG_PATH")
COMMON_VIMRC_CONTENT=$(cat "$COMMON_VIMRC_PATH")

# Create generated_dotfiles directory if it doesn't exist
mkdir -p "$GENERATED_DIR"

# Generate .bashrc
echo "Generating $GENERATED_DIR/.bashrc..."
{ 
  echo "# This file is auto-generated. Do not edit directly."
  echo "# Generated from common_rc/bash_specifics.sh and common_rc/common_shell_config.sh."
  echo "$BASH_SPECIFIC_CONTENT"
  echo ""
  echo "# --- Common Shell Configuration ---"
  echo "$COMMON_CONFIG_CONTENT"
} > "$GENERATED_DIR/.bashrc"

# Generate .zshrc
echo "Generating $GENERATED_DIR/.zshrc..."
{ 
  echo "# This file is auto-generated. Do not edit directly."
  echo "# Generated from common_rc/zsh_specifics.sh and common_rc/common_shell_config.sh."
  echo "$ZSH_SPECIFIC_CONTENT"
  echo ""
  echo "# --- Common Shell Configuration ---"
  echo "$COMMON_CONFIG_CONTENT"
} > "$GENERATED_DIR/.zshrc"

# Generate .vimrc
echo "Generating $GENERATED_DIR/.vimrc..."
{ 
  echo "\" This file is auto-generated. Do not edit directly."
  echo "\" Generated from common_rc/common_vimrc."
  echo ""
  echo "$COMMON_VIMRC_CONTENT"
} > "$GENERATED_DIR/.vimrc"

echo "Dotfile generation complete in $GENERATED_DIR" 