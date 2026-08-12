#!/usr/bin/env bash

set -euo pipefail

# Usage: ./install.sh --laptop | --pc

print_usage() {
	echo "Usage: $0 [--laptop | --pc]"
	exit 1
}

# Check arguments
if [[ $# -ne 1 ]]; then
	print_usage
fi

TARGET=""
if [[ "$1" == "--laptop" ]]; then
	TARGET="laptop"
elif [[ "$1" == "--pc" ]]; then
	TARGET="pc"
else
	print_usage
fi

# Paths
DOTFILES_DIR="$(dirname "$0")"
PKG_DIR="$DOTFILES_DIR/pkg"
SCRIPT_DIR="$DOTFILES_DIR/scripts"

# Ensure yay is installed
if ! command -v yay &> /dev/null; then
	echo "[INFO] yay not found. Installing yay..."
	sudo pacman -Sy --needed git base-devel
	git clone https://aur.archlinux.org/yay.git /tmp/yay
	(cd /tmp/yay && makepkg -si --noconfirm)
	rm -rf /tmp/yay
else
	echo "[INFO] yay is already installed."
fi

# Function: Install packages from a list file
install_pkg_list() {
	local file="$1"
	[[ ! -f "$file" ]] && echo "[WARN] Package list $file not found." && return
	grep -vE '^\s*#' "$file" | grep -vE '^\s*$' | xargs -r yay -S --needed --noconfirm
}

# Step 1: Install shared packages
echo "[STEP] Installing common packages..."
install_pkg_list "$PKG_DIR/common.txt"

# Step 2: Install machine-specific packages
echo "[STEP] Installing ${TARGET} packages..."
install_pkg_list "$PKG_DIR/${TARGET}.txt"

# Step 2.5: Install AUR packages
AUR_LIST="$PKG_DIR/aur.txt"
if [[ -f "$AUR_LIST" ]]; then
	echo "[STEP] Installing AUR packages..."
	grep -vE '^\s*#' "$AUR_LIST" | grep -vE '^\s*$' | xargs -r yay -S --needed --noconfirm
else
	echo "[INFO] No AUR package list found."
fi

# Step 3: Run common setup script
if [[ -x "$SCRIPT_DIR/setup_common.sh" ]]; then
	echo "[STEP] Running shared setup script..."
	bash "$SCRIPT_DIR/setup_common.sh"
fi

# Step 4: Run specific setup script
SPECIFIC_SCRIPT="$SCRIPT_DIR/setup_${TARGET}.sh"
if [[ -x "$SPECIFIC_SCRIPT" ]]; then
	echo "[STEP] Running ${TARGET} setup script..."
	bash "$SPECIFIC_SCRIPT"
fi



# stow
stow_config() {
	local name="$1"
	local path="$DOTFILES_DIR/$name"
	if [[ -d "$path" ]]; then
		echo "[STEP] Stowing $name..."
		stow -v -R -t "$HOME" "$name"
	else
		echo "[WARN] Config directory $name not found."
	fi
}


# Step 5: Stow dotfiles
stow_config "hyprland_$TARGET"
stow_config "ghostty"
stow_config "backgrounds"
stow_config "zsh"
stow_config "tmux"
stow_config "nvim"


# Step 6: Setup Zsh
echo "[STEP] Installing and configuring Zsh..."
# Install oh-my-zsh if not already
OH_MY_ZSH_DIR="$HOME/.oh-my-zsh"
if [[ ! -d "$OH_MY_ZSH_DIR" ]]; then
	echo "[INFO] Installing oh-my-zsh..."
	RUNZSH=no KEEP_ZSHRC=yes \
		sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
	echo "[INFO] oh-my-zsh already installed."
fi

# Clone plugins
ZSH_CUSTOM="$OH_MY_ZSH_DIR/custom"
declare -A plugins=(
	[zsh-autosuggestions]="https://github.com/zsh-users/zsh-autosuggestions"
	[zsh-syntax-highlighting]="https://github.com/zsh-users/zsh-syntax-highlighting"
	[powerlevel10k]="https://github.com/romkatv/powerlevel10k"
)

for plugin in "${!plugins[@]}"; do
	dest_dir="$ZSH_CUSTOM/plugins/$plugin"
	[[ "$plugin" == "powerlevel10k" ]] && dest_dir="$ZSH_CUSTOM/themes/$plugin"

	if [[ ! -d "$dest_dir" ]]; then
		echo "[INFO] Installing $plugin..."
		git clone --depth=1 "${plugins[$plugin]}" "$dest_dir"
	else
		echo "[INFO] $plugin already installed."
	fi
done

# Step 8: Set zsh as default shell
if [[ "$SHELL" != *zsh ]]; then
	echo "[INFO] Setting zsh as default shell..."
	chsh -s "$(command -v zsh)"
else
	echo "[INFO] zsh is already the default shell."
fi


# Step 9: Install and configure tmux
echo "[STEP] Installing tmux..."
# Setup Catppuccin theme
THEME_DIR="$HOME/.config/tmux/plugins/catppuccin"
if [[ ! -d "$THEME_DIR" ]]; then
	echo "[INFO] Installing Catppuccin tmux theme..."
	git clone -b v2.1.3 https://github.com/catppuccin/tmux.git "$THEME_DIR/tmux"
else
	echo "[INFO] Catppuccin tmux theme already installed."
fi



echo "[STEP] Configuring GRUB theme"
theme_file="/usr/share/grub/themes/hyperfluent-grub-theme-arch/theme.txt"
grub_cfg="/etc/default/grub"

if [[ -f "$theme_file" ]]; then
    echo "[STEP] Configuring GRUB to use HyperFluent theme..."

sudo sed -i "s|^#\?\s*GRUB_THEME=.*$|GRUB_THEME=\"$theme_file\"|" "$grub_cfg"
sudo sed -i 's|^GRUB_TERMINAL_OUTPUT=.*|GRUB_TERMINAL_OUTPUT="gfxterm"|' "$grub_cfg"

    # Regenerate GRUB config
    if [[ -d /boot/grub ]]; then
        sudo grub-mkconfig -o /boot/grub/grub.cfg
    elif [[ -d /boot/grub2 ]]; then
        sudo grub2-mkconfig -o /boot/grub2/grub.cfg
    else
        echo "[ERROR] Could not detect GRUB directory. Manual intervention required."
        return 1
    fi
else
    echo "[WARN] Theme file not found: $theme_file"
fi
