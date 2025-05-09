#!/bin/bash

# Exit on any error
set -e

echo "Setting up Vim..."

# Create vim colors directory if it doesn't exist
mkdir -p ~/.vim/colors

# Download jellybeans theme
echo "Downloading jellybeans theme..."
curl -fo ~/.vim/colors/jellybeans.vim https://raw.githubusercontent.com/nanotech/jellybeans.vim/master/colors/jellybeans.vim

# Download pre-generated .vimrc from your repository
GENERATED_VIMRC_URL="https://raw.githubusercontent.com/ishandhanani/setup/main/generated_dotfiles/.vimrc"
echo "Downloading pre-generated .vimrc from $GENERATED_VIMRC_URL..."
if curl -sSL "$GENERATED_VIMRC_URL" -o ~/.vimrc; then
    echo ".vimrc downloaded and installed successfully."
else
    echo "Error: Failed to download .vimrc from $GENERATED_VIMRC_URL." >&2
    echo "Please ensure the file exists in the repository at generated_dotfiles/.vimrc" >&2
    exit 1
fi

echo "Vim setup complete!" 