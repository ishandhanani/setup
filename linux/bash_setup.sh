#!/bin/bash

# Download the pre-generated .bashrc file
GENERATED_BASHRC_URL="https://raw.githubusercontent.com/ishandhanani/setup/main/generated_dotfiles/.bashrc"

echo "Downloading pre-generated .bashrc from $GENERATED_BASHRC_URL..."
if curl -sSL "$GENERATED_BASHRC_URL" -o ~/.bashrc; then
    echo ".bashrc downloaded and installed successfully."
    echo "Run 'source ~/.bashrc' or open a new terminal to apply changes."
    echo "New .bashrc contents:"
    echo "-----------------------------------"
    cat ~/.bashrc
    echo "-----------------------------------"
else
    echo "Error: Failed to download .bashrc from $GENERATED_BASHRC_URL." >&2
    echo "Please ensure the file exists in the repository at generated_dotfiles/.bashrc" >&2
    exit 1
fi