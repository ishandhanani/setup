#!/bin/bash

# macOS specific tool setup

# Minimal bootstrap function to ensure yq is available on macOS
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

# Source the common tool processor script
# Determine script_dir robustly even if sourced or executed directly
script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
COMMON_TOOL_PROCESSOR_PATH="$script_dir/../shared/common_tool_processor.sh"

if [ -f "$COMMON_TOOL_PROCESSOR_PATH" ]; then
    # shellcheck source=../shared/common_tool_processor.sh
    source "$COMMON_TOOL_PROCESSOR_PATH"
else
    echo "Error: Common tool processor not found at $COMMON_TOOL_PROCESSOR_PATH" >&2
    # Attempt to download if running via curl | bash and script_dir might be misleading
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

# Main execution for macOS
main() {
    if [[ "$OSTYPE" != "darwin"* ]]; then
        echo "This script is intended for macOS tool setup."
        echo "For Linux, please use linux/install.sh"
        exit 0 
    fi

    echo "Starting macOS tools setup..."
    bootstrap_yq_macos 
    setup_git # From common_tool_processor.sh
    process_manifest_for_os "macos" # From common_tool_processor.sh
    
    echo "macOS tools setup process complete!"
}

main "$@" 