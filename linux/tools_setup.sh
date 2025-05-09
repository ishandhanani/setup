#!/bin/bash

bootstrap_yq_linux() {
    if ! command -v yq &> /dev/null; then
        echo "yq not found. Attempting to install yq via apt (bootstrap)..."
        # Run apt update only if needed, could be done by a higher level script too
        # For a self-contained script, it's safer to include it.
        if command -v apt-get &> /dev/null; then
            sudo apt-get update 
            sudo apt-get install -y yq
        else
            echo "Error: apt-get not found. Cannot bootstrap yq automatically." >&2
            echo "Please install yq manually and re-run the script." >&2
            exit 1
        fi
        if ! command -v yq &> /dev/null; then
            echo "Error: Failed to bootstrap yq. Please install yq manually." >&2
            exit 1
        fi
        echo "yq bootstrapped successfully via apt."
    else
        echo "yq already available."
    fi
}

# Git Configuration
setup_git() {
    echo "Checking Git configuration..."
    current_name=$(git config --global user.name)
    current_email=$(git config --global user.email)
    
    if [[ "$current_name" != "ishandhanani" || "$current_email" != "ishandhanani@gmail.com" ]]; then
        echo "Setting up Git configuration..."
        git config --global user.name "ishandhanani"
        git config --global user.email "ishandhanani@gmail.com"
        echo "Git config set successfully!"
        echo "Please set GPG key to enable signed commits"
    else
        echo "Git already configured correctly."
    fi
}

# Main tool installation logic using the manifest
install_tools_from_manifest() {
    MANIFEST_URL="https://raw.githubusercontent.com/ishandhanani/setup/main/tool-manifest.yaml"
    MANIFEST_FILE="/tmp/tool-manifest.yaml"

    echo "Downloading tool manifest from $MANIFEST_URL..."
    if ! curl -sSL "$MANIFEST_URL" -o "$MANIFEST_FILE"; then
        echo "Error: Failed to download tool-manifest.yaml." >&2
        exit 1
    fi

    echo "Processing tools from manifest for Linux..."
    
    # Get the number of tools
    num_tools=$(yq e '.tools | length' "$MANIFEST_FILE")

    for i in $(seq 0 $(($num_tools - 1))); do
        tool_name=$(yq e ".tools[$i].name" "$MANIFEST_FILE")
        is_linux_enabled=$(yq e ".tools[$i].linux.enabled" "$MANIFEST_FILE")

        if [ "$is_linux_enabled" == "true" ]; then
            echo "--- Processing tool: $tool_name ---"
            check_cmd=$(yq e ".tools[$i].linux.check_command" "$MANIFEST_FILE")
            install_cmd=$(yq e ".tools[$i].linux.install_command" "$MANIFEST_FILE")

            if [ -z "$check_cmd" ] || [ -z "$install_cmd" ]; then
                echo "Warning: Incomplete configuration for $tool_name on Linux. Skipping." >&2
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
                    # Optionally, decide if this should be a fatal error for the whole script
                fi
            fi
        else
            echo "Skipping $tool_name (not enabled for Linux)."
        fi
        echo # Newline for readability
    done

    rm -f "$MANIFEST_FILE"
}

# Main execution
main() {
    echo "Starting Linux tools setup..."
    bootstrap_yq_linux # Bootstrap yq first
    setup_git 
    install_tools_from_manifest 
    echo "Linux tools setup process complete!"
}

main 