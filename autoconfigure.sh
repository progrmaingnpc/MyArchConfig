#!/bin/bash
WAYBAR_DIRECTORY=~/.config/waybar
HYPRLAND_DIRECTORY=~/.config/hypr

yay -Syu hyprland hyprpaper swww hyprlock waybar \
       xdg-desktop-portal xdg-desktop-portal-hyprland waypaper \
       hypridle hyprpicker hyprland-qt-support hyprland-qtutils \
       hyprcursor hyprutils hyprlang hyprwayland-scanner \
       aquamarine hyprgraphics wl-clipboard qt5-wayland \
       otf-font-awesome

if [ ! -d "$HYPRLAND_DIRECTORY" ]; then	
	mkdir "$HYPRLAND_DIRECTORY"
	echo "Created local hyprland directory at $HYPRLAND_DIRECTORY"
else
	echo "Found existing local hyprland directory at $HYPRLAND_DIRECTORY"
fi

cp hyprland_confs/confs/new_confs/*.conf ~/.config/hypr -v

if [ ! -d "$WAYBAR_DIRECTORY" ]; then	
	mkdir "$WAYBAR_DIRECTORY"
	echo "Created local waybar directory at $WAYBAR_DIRECTORY"
else
	echo "Found existing local waybar directory at $WAYBAR_DIRECTORY"
fi

cp hyprland_confs/waybar_confs/*.jsonc ~/.config/waybar -v
cp hyprland_confs/waybar_confs/*.css ~/.config/waybar -v 
