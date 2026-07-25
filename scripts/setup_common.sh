#!/usr/bin/env bash

# Common system config (git, ssh, etc.)

# Git identity
git config --global user.name "teotoivo"
git config --global user.email "teo.maximilien@gmail.com"

# Enable and start SSH
sudo systemctl enable sshd
sudo systemctl start sshd

# Set zsh as default shell
if [[ "$SHELL" != "/bin/zsh" ]]; then
	chsh -s /bin/zsh
fi

