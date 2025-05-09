#!/bin/bash

# Exit on any error
set -e

GITHUB_BASE_URL="https://raw.githubusercontent.com/ishandhanani/setup/main/linux"

echo "Starting Linux (Ubuntu) setup..."

# Run Bash Setup
echo "-----------------------------------"
echo "Setting up Bash..."
if bash <(curl -sSL "$GITHUB_BASE_URL/bash_setup.sh"); then
    echo "Bash setup successful."
else
    echo "Bash setup failed."
    exit 1
fi

# Run Vim Setup
echo "-----------------------------------"
echo "Setting up Vim..."
if bash <(curl -sSL "$GITHUB_BASE_URL/vim_setup.sh"); then
    echo "Vim setup successful."
else
    echo "Vim setup failed."
    exit 1
fi

# Run Tools Setup
echo "-----------------------------------"
echo "Installing tools..."
if bash <(curl -sSL "$GITHUB_BASE_URL/tools_setup.sh"); then
    echo "Tools installation successful."
else
    echo "Tools installation failed."
    exit 1
fi

echo "-----------------------------------"
echo "Linux setup process complete!"
echo "Please source your ~/.bashrc or open a new terminal to apply all changes." 