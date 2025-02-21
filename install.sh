#!/bin/bash

# Define the dotfiles directory
DOTFILES_DIR="$HOME/dotfiles"

# Symlink oh-my-zsh
ln -sf "$DOTFILES_DIR/.oh-my-zsh" "$HOME/.oh-my-zsh"

# Symlink zshrc
ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"

# Symlink p10k.zsh
ln -sf "$DOTFILES_DIR/.p10k.zsh" "$HOME/.p10k.zsh"

# Symlink tmux.conf
ln -sf "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"

# Symlink Neovim config
mkdir -p "$HOME/.config"
ln -sf "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"

echo "Dotfiles installed successfully!"
