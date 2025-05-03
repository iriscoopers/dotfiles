#!/bin/bash

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

# Create necessary directories if they don't exist
mkdir -p "$HOME/.config/nvim/lua"

# Remove existing symlinks or files if they exist
rm -f "$HOME/.config/nvim/lua/"*

# Create symlinks for all lua files
for file in "$DOTFILES_DIR/config/nvim/lua/"*.lua; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        ln -s "$file" "$HOME/.config/nvim/lua/$filename"
        echo "Created symlink: $HOME/.config/nvim/lua/$filename -> $file"
    fi
done

echo "Neovim symlinks setup complete!" 