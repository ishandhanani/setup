#!/bin/bash

# Minimal bootstrap function to ensure yq is available on macOS
# This runs BEFORE manifest processing and cannot rely on the manifest.
bootstrap_yq_macos() {
    if ! command -v yq &> /dev/null; then
        echo "yq not found. Attempting to install yq via Homebrew (bootstrap)..."
        if command -v brew &> /dev/null; then
            brew install yq
        else
            echo "Error: Homebrew not found. Cannot bootstrap yq automatically." >&2
            echo "Please install Homebrew, then yq manually and re-run the script." >&2
            exit 1
        fi
        if ! command -v yq &> /dev/null; then
            echo "Error: Failed to bootstrap yq. Please install yq manually." >&2
            exit 1
        fi
        echo "yq bootstrapped successfully via Homebrew."
    else
        echo "yq already available."
    fi
}

# Git Configuration (global)
setup_git() {
    echo "Checking Git configuration..."
    current_name=$(git config --global user.name)
    current_email=$(git config --global user.email)
    if [[ "$current_name" != "ishandhanani" || "$current_email" != "ishandhanani@gmail.com" ]]; then
        echo "Setting up Git configuration..."
        git config --global user.name "ishandhanani"
        git config --global user.email "ishandhanani@gmail.com"
        echo "Git config set successfully!"
    else
        echo "Git already configured correctly."
    fi
}

# Main tool installation logic using the manifest for macOS
install_macos_tools_from_manifest() {
    MANIFEST_URL="https://raw.githubusercontent.com/ishandhanani/setup/main/tool-manifest.yaml"
    MANIFEST_FILE="/tmp/tool-manifest.yaml"

    echo "Downloading tool manifest from $MANIFEST_URL..."
    if ! curl -sSL "$MANIFEST_URL" -o "$MANIFEST_FILE"; then
        echo "Error: Failed to download tool-manifest.yaml." >&2
        exit 1
    fi

    echo "Processing tools from manifest for macOS..."
    num_tools=$(yq e '.tools | length' "$MANIFEST_FILE")

    for i in $(seq 0 $(($num_tools - 1))); do
        tool_name=$(yq e ".tools[$i].name" "$MANIFEST_FILE")
        is_macos_enabled=$(yq e ".tools[$i].macos.enabled" "$MANIFEST_FILE")

        if [ "$is_macos_enabled" == "true" ]; then
            echo "--- Processing tool: $tool_name ---"
            check_cmd=$(yq e ".tools[$i].macos.check_command" "$MANIFEST_FILE")
            install_cmd=$(yq e ".tools[$i].macos.install_command" "$MANIFEST_FILE")

            if [ -z "$check_cmd" ] || [ -z "$install_cmd" ]; then
                echo "Warning: Incomplete configuration for $tool_name on macOS. Skipping." >&2
                continue
            fi

            echo "Checking if $tool_name is installed (using: $check_cmd)..."
            if eval "$check_cmd" &> /dev/null; then
                echo "$tool_name is already installed."
            else
                echo "$tool_name not found. Attempting to install (using: $install_cmd)..."
                if eval "$install_cmd"; then
                    echo "$tool_name installed successfully."
                else
                    echo "Error: Failed to install $tool_name." >&2
                fi
            fi
        else
            echo "Skipping $tool_name (not enabled for macOS)."
        fi
        echo
    done
    rm -f "$MANIFEST_FILE"
}

# Main execution
main() {
    if [[ "$OSTYPE" != "darwin"* ]]; then
        # This check might seem redundant if the script is in darwin/
        # but it's good practice if the script were ever called from a different context.
        echo "This script is intended for macOS tool setup."
        echo "For Linux, please use linux/install.sh"
        exit 0 
    fi

    echo "Starting macOS tools setup..."
    bootstrap_yq_macos 
    setup_git 
    install_macos_tools_from_manifest
    
    echo "macOS tools setup process complete!"
}

main "$@" 