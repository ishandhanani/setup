#!/bin/bash

# Shared functions for tool processing and Git setup

# Git Configuration (global and common)
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

# Process tool manifest for a given OS
# Arguments:
#   $1: OS identifier string (e.g., "macos" or "linux")
process_manifest_for_os() {
    local os_id="$1"
    if [ -z "$os_id" ]; then
        echo "Error: OS identifier not provided to process_manifest_for_os." >&2
        return 1
    fi

    MANIFEST_URL="https://raw.githubusercontent.com/ishandhanani/setup/main/tool-manifest.yaml"
    MANIFEST_FILE="/tmp/tool-manifest.yaml"

    echo "Downloading tool manifest from $MANIFEST_URL..."
    if ! curl -sSL "$MANIFEST_URL" -o "$MANIFEST_FILE"; then
        echo "Error: Failed to download tool-manifest.yaml." >&2
        return 1 # Use return for function errors
    fi

    echo "Processing tools from manifest for OS: $os_id..."
    num_tools=$(yq e '.tools | length' "$MANIFEST_FILE")

    for i in $(seq 0 $(($num_tools - 1))); do
        tool_name=$(yq e ".tools[$i].name" "$MANIFEST_FILE")
        is_os_enabled=$(yq e ".tools[$i].${os_id}.enabled" "$MANIFEST_FILE")

        if [ "$is_os_enabled" == "true" ]; then
            echo "--- Processing tool: $tool_name for $os_id ---"
            check_cmd=$(yq e ".tools[$i].${os_id}.check_command" "$MANIFEST_FILE")
            install_cmd=$(yq e ".tools[$i].${os_id}.install_command" "$MANIFEST_FILE")

            if [ -z "$check_cmd" ] || [ -z "$install_cmd" ]; then
                echo "Warning: Incomplete configuration for $tool_name on $os_id. Skipping." >&2
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

            post_install_cmd=$(yq e ".tools[$i].${os_id}.post_install_command" "$MANIFEST_FILE")
            if [ -n "$post_install_cmd" ]; then
                echo "Running post-install command for $tool_name on $os_id..."
                eval "$post_install_cmd"
            fi
        else
            echo "Skipping $tool_name (not enabled for $os_id)."
        fi
        echo
    done
    rm -f "$MANIFEST_FILE"
    return 0
} 