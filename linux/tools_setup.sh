#!/bin/bash

# Linux specific tool setup

# Minimal bootstrap function to ensure yq is available on Linux (Ubuntu)
bootstrap_yq_linux() {
    if ! command -v yq &> /dev/null; then
        echo "yq not found. Attempting to install yq via wget (bootstrap)..."
        # Ensure wget is available or add it to manifest / bootstrap it too if necessary
        sudo wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/local/bin/yq && \
        sudo chmod +x /usr/local/bin/yq
        if ! command -v yq &> /dev/null; then
            echo "Error: Failed to bootstrap yq. Please install yq manually." >&2
            exit 1
        fi
        echo "yq bootstrapped successfully via wget."
    else
        echo "yq already available."
    fi
}

# Source the common tool processor script
# Determine script_dir robustly
script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
COMMON_TOOL_PROCESSOR_PATH="$script_dir/../shared/common_tool_processor.sh"

if [ -f "$COMMON_TOOL_PROCESSOR_PATH" ]; then
    # shellcheck source=../shared/common_tool_processor.sh
    source "$COMMON_TOOL_PROCESSOR_PATH"
else
    echo "Error: Common tool processor not found at $COMMON_TOOL_PROCESSOR_PATH" >&2
    echo "Attempting to download common_tool_processor.sh from repository..."
    COMMON_PROCESSOR_URL="https://raw.githubusercontent.com/ishandhanani/setup/main/shared/common_tool_processor.sh"
    TEMP_COMMON_PROCESSOR="/tmp/common_tool_processor.sh"
    if curl -sSL "$COMMON_PROCESSOR_URL" -o "$TEMP_COMMON_PROCESSOR"; then
        source "$TEMP_COMMON_PROCESSOR"
        rm "$TEMP_COMMON_PROCESSOR"
    else 
        echo "Failed to download common_tool_processor.sh. Exiting." >&2
        exit 1
    fi
fi

# Main execution for Linux
main() {
    echo "Starting Linux tools setup..."
    bootstrap_yq_linux 
    setup_git # From common_tool_processor.sh
    process_manifest_for_os "linux" # From common_tool_processor.sh
    echo "Linux tools setup process complete!"
}

main "$@" 