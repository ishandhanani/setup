#!/bin/bash

# Script to preview the content of generated .bashrc and .zshrc files

set -e # Exit on error

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
REPO_ROOT="$SCRIPT_DIR/.."
CONFIG_SOURCE_DIR="$REPO_ROOT/common_rc"

COMMON_CONFIG_PATH="$CONFIG_SOURCE_DIR/common_shell_config.sh"
ZSH_SPECIFIC_CONFIG_PATH="$CONFIG_SOURCE_DIR/zsh_specifics.sh"
BASH_SPECIFIC_CONFIG_PATH="$CONFIG_SOURCE_DIR/bash_specifics.sh"

# --- Helper function to check for file existence ---
check_file_exists() {
    local file_path="$1"
    local file_desc="$2"
    if [ ! -f "$file_path" ]; then
        echo "Error: $file_desc not found at $file_path" >&2
        exit 1
    fi
}

# --- Check for source files ---
check_file_exists "$COMMON_CONFIG_PATH" "Common shell config"
check_file_exists "$ZSH_SPECIFIC_CONFIG_PATH" "Zsh specific config"
check_file_exists "$BASH_SPECIFIC_CONFIG_PATH" "Bash specific config"

# --- Read content --- 
COMMON_CONFIG_CONTENT=$(cat "$COMMON_CONFIG_PATH")
ZSH_SPECIFIC_CONTENT=$(cat "$ZSH_SPECIFIC_CONFIG_PATH")
BASH_SPECIFIC_CONTENT=$(cat "$BASH_SPECIFIC_CONFIG_PATH")

# --- Preview .bashrc --- 
echo "---------------------------------------------------------------------"
echo "PREVIEW: Generated .bashrc"
echo "---------------------------------------------------------------------"
echo "# This is a preview of the auto-generated .bashrc."
echo "# It would be generated from common_rc/bash_specifics.sh and common_rc/common_shell_config.sh."
echo ""
echo "$BASH_SPECIFIC_CONTENT"
echo ""
echo "# --- Common Shell Configuration --- "
echo "$COMMON_CONFIG_CONTENT"
echo "---------------------------------------------------------------------
"

# --- Preview .zshrc --- 
echo "---------------------------------------------------------------------"
echo "PREVIEW: Generated .zshrc"
echo "---------------------------------------------------------------------"
echo "# This is a preview of the auto-generated .zshrc."
echo "# It would be generated from common_rc/zsh_specifics.sh and common_rc/common_shell_config.sh."
echo ""
echo "$ZSH_SPECIFIC_CONTENT"
echo ""
echo "# --- Common Shell Configuration --- "
echo "$COMMON_CONFIG_CONTENT"
echo "---------------------------------------------------------------------"

echo "Preview complete." 