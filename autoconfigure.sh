#!/bin/bash

HYPRLAND_DIRECTORY=~/.config/hypr
HYPR_CONF_DIRECTORY=~/.config/hypr/conf
KITTY_DIRECTORY=~/.config/kitty
WAYBAR_DIRECTORY=~/.config/waybar

yay -Syu hyprland hyprpaper swww hyprlock waybar \
       xdg-desktop-portal xdg-desktop-portal-hyprland waypaper \
       hypridle hyprpicker hyprland-qt-support hyprland-qtutils \
       hyprcursor hyprutils hyprlang hyprwayland-scanner \
       aquamarine hyprgraphics wl-clipboard qt5-wayland \
       otf-font-awesome kitty oh-my-posh
# Create the hyprland directory (hypr) if it doesn't already exist
if [ ! -d "$HYPRLAND_DIRECTORY" ]; then	
	mkdir "$HYPRLAND_DIRECTORY"
	echo "Created local hyprland directory at $HYPRLAND_DIRECTORY"
else
	echo "Found existing local hyprland directory at $HYPRLAND_DIRECTORY"
fi
# Create the conf directory if doesn't already exist
if [ ! -d "$HYPR_CONF_DIRECTORY" ]; then	
	mkdir "$HYPR_CONF_DIRECTORY"
	echo "Created local hyprland config directory at $HYPR_CONF_DIRECTORY"
else
	echo "Found existing local hyprland config directory at $HYPR_CONF_DIRECTORY"
fi
# Create the kitty directory if doesn't already exist
if [ ! -d "$KITTY_DIRECTORY" ]; then	
	mkdir "$KITTY_DIRECTORY"
	echo "Created local kitty directory at $KITTY_DIRECTORY"
else
	echo "Found existing local kitty directory at $KITTY_DIRECTORY"
fi
# Create the waybar directory if doesn't already exist
if [ ! -d "$WAYBAR_DIRECTORY" ]; then	
	mkdir "$WAYBAR_DIRECTORY"
	echo "Created local waybar directory at $WAYBAR_DIRECTORY"
else
	echo "Found existing local waybar directory at $WAYBAR_DIRECTORY"
fi

# Copy the hyprland configs to the hyprland directory on the user's device
cp hyprland_confs/confs/new_confs/*.conf "$HYPRLAND_DIRECTORY" -v
# Copy the hyprland configs to the hyprland config directory on the user's device
cp hyprland_confs/confs/new_confs/conf/*.conf "$HYPR_CONF_DIRECTORY" -v
# Copy the kitty configs to the kitty config directory on the user's device
cp hyprland_confs/kitty/*.conf "$KITTY_DIRECTORY" -v
# Copy the waybar configs to the waybar config directory on the user's device
cp hyprland_confs/waybar_confs/*.jsonc "$WAYBAR_DIRECTORY" -v
cp hyprland_confs/waybar_confs/*.css "$WAYBAR_DIRECTORY" -v
# Copy the bash config file to the user's .bashrc file
cp hyprland_confs/bashrc/bash_conf ~/.bashrc -v
# Copy the zsh config file to the user's .zshrc file
cp hyprland_confs/zshrc/zsh_conf ~/.zshrc -v
