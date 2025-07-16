#!/bin/bash

HYPRLAND_DIRECTORY=~/.config/hypr
HYPR_CONF_DIRECTORY=~/.config/hypr/conf
KITTY_DIRECTORY=~/.config/kitty
WAYBAR_DIRECTORY=~/.config/waybar
SHELL_FASTFETCH_DIRECTORY=~/.config/fast_fetch_shell
WAYPAPER_DIRECTORY=~/.config/waypaper 
SCRIPTS_DIRECTORY=~/.config/hypr/scripts

yay -Syu hyprland hyprpaper swww hyprlock waybar \
       xdg-desktop-portal xdg-desktop-portal-hyprland waypaper \
       hypridle hyprpicker hyprland-qt-support hyprland-qtutils \
       hyprcursor hyprutils hyprlang hyprwayland-scanner \
       aquamarine hyprgraphics wl-clipboard qt5-wayland \
       otf-font-awesome kitty oh-my-posh-bin bash-completion \
       zsh-completions rofi-wayland tor tor-browser-bin wireshark-cli \
       wireshark-qt rustup postgresql zed fastfetch wallust
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
# Create the fastfetch shell config directory if doesn't already exist
if [ ! -d "$SHELL_FASTFETCH_DIRECTORY" ]; then	
	mkdir "$SHELL_FASTFETCH_DIRECTORY"
	echo "Created local fastfetch shell config directory at $SHELL_FASTFETCH_DIRECTORY"
else
	echo "Found existing local fastfetch shell config directory at $SHELL_FASTFETCH_DIRECTORY" 
fi
# Create the waypaper directory if doesn't already exist
if [ ! -d "$WAYPAPER_DIRECTORY" ]; then	
	mkdir "$WAYPAPER_DIRECTORY"
	echo "Created local waypaper directory at $WAYPAPER_DIRECTORY"
else
	echo "Found existing local waypaper directory at $WAYPAPER_DIRECTORY" 
fi
# Create the hyprland scripts directory if doesn't already exist
if [ ! -d "$SCRIPTS_DIRECTORY" ]; then	
	mkdir "$SCRIPTS_DIRECTORY"
	echo "Created local scripts directory at $SCRIPTS_DIRECTORY"
else
	echo "Found existing local scripts directory at $SCRIPTS_DIRECTORY" 
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
# Copy the fastfetch shell config to the fastfetch shell config directory on the user's device
cp hyprland_confs/fast_fetch_conf/default.jsonc "$SHELL_FASTFETCH_DIRECTORY" -v
cp hyprland_confs/fast_fetch_conf/default.png "$SHELL_FASTFETCH_DIRECTORY" -v
# Install oh-my-posh font
oh-my-posh font install JetBrainsMono
# Copy default wallpaper directory with default background to user's directory
cp wallpaper/ ~/ -r -v
cp hyprland_confs/waypaper_conf/config.ini "$WAYPAPER_DIRECTORY" -v
cp personal_scripts/*.sh "$SCRIPTS_DIRECTORY" -v

waypaper --wallpaper ~/wallpaper/default.jpg
sudo usermod -aG wireshark $USER
