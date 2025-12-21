#!/bin/bash
HYPRLAND_DIRECTORY=~/.config/hypr
KITTY_DIRECTORY=~/.config/kitty
WAYBAR_DIRECTORY=~/.config/waybar
SHELL_FASTFETCH_DIRECTORY=~/.config/fast_fetch_shell
WAYPAPER_DIRECTORY=~/.config/waypaper
NVIM_DIRECTORY=~/.config/nvim
TMUX_DIRECTORY=~/.config/tmux
NWG_DOCK_DIRECTORY=~/.config/nwg-dock-hyprland
GTK_THEMES_DIR=~/.themes
CURRENT_DIR=$(pwd)

sudo pacman -Syu
sudo pacman -S git --noconfirm --needed
echo "$CURRENT_DIR"

# Install the paru AUR manager if there isn't one
if ! command -v paru &> /dev/null && ! command -v yay &> /dev/null; then
    echo "[No AUR manager installed, installing paru]"
    git clone https://aur.archlinux.org/paru.git $HOME/paru
	makepkg -si --dir $HOME/paru
	echo "Yay has been installed at $HOME/paru"
fi

if command -v yay &> /dev/null; then
    AUR_MANAGER=yay
    echo "Yay is installed."
fi

if command -v paru &> /dev/null; then
    AUR_MANAGER=paru
    echo "Paru is installed."
fi

$AUR_MANAGER -Syu

$AUR_MANAGER -S hyprland hyprpaper hyprlock --noconfirm --needed

$AUR_MANAGER -S hypridle hyprpicker hyprland-qt-support hyprland-qtutils \
	hyprcursor hyprutils hyprlang hyprwayland-scanner \
	hyprgraphics hyprpolkitagent hyprsysteminfo hyprsunset wlogout --noconfirm --needed
echo "[Successfully installed basic utilities for hyprland]"

$AUR_MANAGER -S swww waybar waypaper aquamarine swaync nautilus btop htop hardinfo2 libnotify jq --noconfirm --needed
echo "[Successfully installed file system management packages]"

$AUR_MANAGER -S nwg-look nwg-dock-hyprland grim slurp wl-clipboard --noconfirm --needed
echo "[Successfully installed dock for hyprland]"

$AUR_MANAGER -S wl-clipboard qt5-wayland qt6-wayland qt6ct otf-font-awesome rofi-wayland --noconfirm --needed
echo "Finished installing hyprland configuration packages"

$AUR_MANAGER -S kitty zsh oh-my-posh-bin bash-completion \
   	zsh-completions fastfetch python-pywal16 postgresql --noconfirm --needed
echo "[Finished installing shell configuration packages]"

# Import keys required to install the Tor browser
gpg --keyserver hkps://keys.openpgp.org --recv-keys EF6E286DDA85EA2A4BA7DE684E2C6E8793298290

$AUR_MANAGER -S networkmanager tor tor-browser-bin wireshark-cli \
    wireshark-qt zed pavucontrol power-profiles-daemon brave-bin discord --noconfirm --needed
echo "[Finished installing basic apps]"

$AUR_MANAGER -S xdg-desktop-portal xdg-desktop-portal-hyprland \
   	xdg-desktop-portal-gtk xdg-desktop-portal-wlr xdg-desktop-portal-lxqt \
    xdg-desktop-portal-kde xdg-desktop-portal-gnome --noconfirm --needed
echo "[Finished installing xdg-desktop packages]"

$AUR_MANAGER -S gtk4 gtk2 papirus-icon-theme breeze noto-fonts noto-fonts-emoji libadwaita \
    noto-fonts-cjk noto-fonts-extra --noconfirm --needed
echo "[Successfully installed gtk esthetic packages]"

$AUR_MANAGER -S vim neovim --noconfirm --needed
echo "[Succesfully installed neovim and vim]"

$AUR_MANAGER -S lua luarocks --noconfirm --needed
echo "[Successfully installed lua packages for neovim configuration]"

$AUR_MANAGER -S pipes.sh cava neo-matrix --noconfirm --needed
echo "[Successfully installed ricing apps]"

$AUR_MANAGER -S tmux --noconfirm --needed
echo "[Successfully installed tmux]"

$AUR_MANAGER -S gnome-keyring kleopatra
echo "[Successfully installed kwallet and kleopatra]"

$AUR_MANAGER -S ttf-dejavu ttf-liberation noto-fonts noto-fonts-emoji ttf-font-awesome nerd-fonts
echo "[Successfully installed fonts]"

# Create the hyprland directory (hypr) if it doesn't already exist
if [ ! -d "$HYPRLAND_DIRECTORY" ]; then
	mkdir "$HYPRLAND_DIRECTORY"
	echo "Created local hyprland directory at $HYPRLAND_DIRECTORY"
else
	echo "Found existing local hyprland directory at $HYPRLAND_DIRECTORY"
fi
# Create the waybar directory if doesn't already exist
if [ ! -d "$WAYBAR_DIRECTORY" ]; then
	mkdir "$WAYBAR_DIRECTORY"
	echo "Created local waybar directory at $WAYBAR_DIRECTORY"
else
	echo "Found existing local waybar directory at $WAYBAR_DIRECTORY"
fi
# Create the kitty directory if doesn't already exist
if [ ! -d "$KITTY_DIRECTORY" ]; then
	mkdir "$KITTY_DIRECTORY"
	echo "Created local kitty directory at $KITTY_DIRECTORY"
else
	echo "Found existing local kitty directory at $KITTY_DIRECTORY"
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
# Create the neovim directory if it doesn't already exist
if [ ! -d "$NVIM_DIRECTORY" ]; then
	mkdir "$NVIM_DIRECTORY"
	echo "Created neovim directory at $NVIM_DIRECTORY"
else
	echo "Found existing neovim directory at $NVIM_DIRECTORY"
fi
# Create the tmux config directory if it doesn't already exist
if [ ! -d "$TMUX_DIRECTORY" ]; then
	mkdir "$TMUX_DIRECTORY"
	echo "Created tmux directory at $TMUX_DIRECTORY"
else
	echo "Found existing tmux directory at $TMUX_DIRECTORY"
fi
# Create the nwg-dock config directory if it doesn't already exist
if [ ! -d "$NWG_DOCK_DIRECTORY" ]; then
	mkdir "$NWG_DOCK_DIRECTORY"
	echo "Created nwg-dock directory at $NWG_DOCK_DIRECTORY"
else
	echo "Found existing nwg-dock directory at $NWG_DOCK_DIRECTORY"
fi
# Create the gtk themes directory if it doesn't already exist
if [ ! -d "$GTK_THEMES_DIR" ]; then
	mkdir "$GTK_THEMES_DIR"
	echo "Created gtk directory at $GTK_THEMES_DIR"
else
	echo "Found existing gtk directory at $GTK_THEMES_DIR"
fi
# Copy the hyprland configs to the hyprland directory on the user's device
cp $CURRENT_DIR/confs/hyprland_confs/*.conf "$HYPRLAND_DIRECTORY" -v
# Copy the hyprland configs to the hyprland config directory on the user's device
cp $CURRENT_DIR/confs/hyprland_confs/conf "$HYPRLAND_DIRECTORY" -r -v
# # Copy hyprland scripts directory to user's hyprland config directory
cp $CURRENT_DIR/scripts "$HYPRLAND_DIRECTORY" -r -v
# Copy the waybar configs to the waybar config directory on the user's device
cp $CURRENT_DIR/confs/waybar_confs/*.jsonc "$WAYBAR_DIRECTORY" -v
cp $CURRENT_DIR/confs/waybar_confs/*.css "$WAYBAR_DIRECTORY" -v
# Copy the kitty configs to the kitty config directory on the user's device
cp $CURRENT_DIR/confs/terminal_conf/kitty/*.conf "$KITTY_DIRECTORY" -v
# Copy the bash config file to the user's .bashrc file
cp $CURRENT_DIR/confs/terminal_conf/shells/bashrc/bash_conf ~/.bashrc -v
# Copy the zsh config file to the user's .zshrc file
cp $CURRENT_DIR/confs/terminal_conf/shells/zshrc/zsh_conf ~/.zshrc -v
# Copy the fastfetch shell config to the fastfetch shell config directory on the user's device
cp $CURRENT_DIR/confs/terminal_conf/fast_fetch_conf/default.* "$SHELL_FASTFETCH_DIRECTORY" -v
# Copy default wallpaper directory with default background to user's directory
cp $CURRENT_DIR/wallpaper/ ~/ -r -v
# Copy waypaper config to user's wallpaper directory
cp $CURRENT_DIR/confs/waypaper_conf/config.ini "$WAYPAPER_DIRECTORY" -v
# Copy neovim config file to the user's neovim config directory
cp $CURRENT_DIR/confs/nvim_confs/init.lua "$NVIM_DIRECTORY" -v
# Copy neovim lua config files to the user's neovim lua config directory
cp $CURRENT_DIR/confs/nvim_confs/lua "$NVIM_DIRECTORY" -r -v
# Copy tmux config files to the user's tmux config directory
cp $CURRENT_DIR/confs/tmux_confs/*.conf "$TMUX_DIRECTORY" -v
# Copy nwg-dock config files to the user's nwg-dock config directory
cp $CURRENT_DIR/confs/nwg_dock_conf/*.css "$NWG_DOCK_DIRECTORY" -v

# Configure luarocks to use the user directory by default for lua package management
luarocks config local_by_default true
luarocks install stdlib --local
# Install oh-my-posh font
oh-my-posh font install JetBrainsMono
# Set shell color scheme according to default wallpaper
wal -i ~/wallpaper/default.jpg
# Display the default wallpaper
waypaper --wallpaper ~/wallpaper/default.jpg
# Make add current user to wireshark group (to allow running wireshark in promiscuous mode)
sudo usermod -aG wireshark $USER

# Create the hyprland directory (hypr) if it doesn't already exist
if [ "$SHELL" != $(which zsh) ]; then
    sudo chsh -s $(which zsh) $USER
    echo "[Changed the default shell from $SHELL=>$(which zsh)]"
else
	echo "[The default shell is zsh]"
fi

# Check if the user loves candy :)
sed -n '/ILoveCandy/q 0;$q 1' /etc/pacman.conf
if [ "$?" != 0 ]; then
    sudo sed -i '/Misc options/a ILoveCandy' /etc/pacman.conf
    echo "[NOW YOU HAVE CANDY, HURRAY!!]"
else
    echo "[I LOVE CANDY]"
fi

echo "[Please restart to allow all changes to take effect]"
