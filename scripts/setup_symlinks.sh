#!/bin/bash

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

# Function to create symlinks for a directory
create_symlinks() {
    local source_dir="$1"
    local target_dir="$2"
    local exclude_pattern="$3"

    # Create target directory if it doesn't exist
    mkdir -p "$target_dir"

    # Loop through all files and directories in source
    for item in "$source_dir"/*; do
        if [ -e "$item" ]; then
            local filename=$(basename "$item")
            
            # Skip if filename matches exclude pattern
            if [[ -n "$exclude_pattern" && "$filename" =~ $exclude_pattern ]]; then
                continue
            fi

            # If it's a directory, recurse into it
            if [ -d "$item" ]; then
                create_symlinks "$item" "$target_dir/$filename" "$exclude_pattern"
            else
                # Remove existing symlink or file
                rm -f "$target_dir/$filename"

                # Create symlink
                ln -s "$item" "$target_dir/$filename"
                echo "Created symlink: $target_dir/$filename -> $item"
            fi
        fi
    done
}

# Special function for Neovim lua files
setup_nvim_lua_symlinks() {
    local nvim_lua_dir="$DOTFILES_DIR/config/nvim/lua"
    local target_lua_dir="$HOME/.config/nvim/lua"

    # Create target directory
    mkdir -p "$target_lua_dir"

    # Remove existing files in target directory
    rm -f "$target_lua_dir"/*.lua

    # Create symlinks for all .lua files
    for lua_file in "$nvim_lua_dir"/*.lua; do
        if [ -f "$lua_file" ]; then
            local filename=$(basename "$lua_file")
            ln -s "$lua_file" "$target_lua_dir/$filename"
            echo "Created symlink: $target_lua_dir/$filename -> $lua_file"
        fi
    done
}

# Create symlinks for config directory
rm -rf "$HOME/.config/nvim"
create_symlinks "$DOTFILES_DIR/config" "$HOME/.config" ""

# Set up Neovim lua symlinks
setup_nvim_lua_symlinks

# Create symlinks for vim directory
create_symlinks "$DOTFILES_DIR/vim" "$HOME/.vim" ""

# Create symlinks for git directory
create_symlinks "$DOTFILES_DIR/git" "$HOME" ""

# Create symlinks for ack directory
create_symlinks "$DOTFILES_DIR/ack" "$HOME" ""

# Create symlinks for alacritty directory
create_symlinks "$DOTFILES_DIR/alacritty" "$HOME/.config/alacritty" ""

# Create symlinks for tmux directory
create_symlinks "$DOTFILES_DIR/tmux" "$HOME" ""

# Create symlinks for shell directory, excluding iTerm files
create_symlinks "$DOTFILES_DIR/shell" "$HOME" ".*iterm.*"

# Special handling for .zsh directory
if [ -d "$DOTFILES_DIR/shell/.zsh" ]; then
    mkdir -p "$HOME/.zsh"
    create_symlinks "$DOTFILES_DIR/shell/.zsh" "$HOME/.zsh" ".*iterm.*"
fi

echo "Symlinks setup complete!" 