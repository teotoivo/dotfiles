#!/usr/bin/env bash

# Laptop-specific tweaks
echo "[INFO] Enabling TLP for battery saving..."
sudo systemctl enable tlp
sudo systemctl start tlp

