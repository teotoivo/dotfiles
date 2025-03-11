#!/bin/bash

# Define the options for the power menu
options="Shutdown\nRestart\nLogout\nCancel"

# Use wofi to display the options and capture the selected option
choice=$(echo -e "$options" | wofi --dmenu --prompt "Power" --lines=10)

case "$choice" in
    Shutdown)
        systemctl poweroff
        ;;
    Restart)
        systemctl reboot
        ;;
    Logout)
        # Adjust this command depending on your session manager; this is an example for Hyprland
        hyprctl dispatch exit
        ;;
    *)
        # If Cancel or an unknown option, do nothing
        ;;
esac

