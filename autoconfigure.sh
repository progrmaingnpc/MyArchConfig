#!/bin/bash
HYPRLAND_DIR=~/.config/hypr
KITTY_DIR=~/.config/kitty
WAYBAR_DIR=~/.config/waybar
WLOGOUT_DIR=~/.config/wlogout
SHELL_FASTFETCH_DIR=~/.config/fast_fetch_shell
WAYPAPER_DIR=~/.config/waypaper
NVIM_DIR=~/.config/nvim
TMUX_DIR=~/.config/tmux
NWG_DOCK_DIR=~/.config/nwg-dock-hyprland
GTK_THEMES_DIR=~/.themes
YAZI_DIR=~/.config/yazi
CARGO_DIR=~/.cargo
CURRENT_DIR=$(pwd)

sudo pacman -Syu
sudo pacman -S git base-devel github-cli --noconfirm --needed
echo "$CURRENT_DIR"

# Install the paru AUR manager if there isn't one
if ! command -v paru &> /dev/null && ! command -v yay &> /dev/null; then
    echo "[No AUR manager installed, installing paru]"
    git clone https://aur.archlinux.org/paru.git $HOME/paru
    makepkg -si --dir $HOME/paru
    echo "Paru has been installed at $HOME/paru"
fi

if command -v yay &> /dev/null; then
    AUR_MANAGER=yay
    echo "Yay is installed."
elif command -v paru &> /dev/null; then
    AUR_MANAGER=paru
    echo "Paru is installed."
else 
    echo "Failed to install an AUR"
    exit
fi

$AUR_MANAGER

$AUR_MANAGER -S hyprland hyprpaper hyprlock --noconfirm --needed

$AUR_MANAGER -S hypridle hyprpicker hyprland-qt-support hyprland-guiutils \
	hyprcursor hyprutils hyprlang hyprwayland-scanner hyprpwcenter hyprshutdown \
	hyprgraphics hyprpolkitagent hyprsunset hyprqt6engine hyprlauncher \
	wlogout blueman --noconfirm --needed
echo "[Successfully installed basic utilities for hyprland]"

$AUR_MANAGER -S awww waybar waypaper-git aquamarine swaync nautilus btop htop hardinfo2 libnotify jq --noconfirm --needed
echo "[Successfully installed file system management packages]"

$AUR_MANAGER -S nwg-look nwg-dock-hyprland grimblast-git slurp wl-clipboard --noconfirm --needed
echo "[Successfully installed dock for hyprland]"

$AUR_MANAGER -S wl-clipboard qt5-wayland qt6-wayland qt6ct otf-font-awesome --noconfirm --needed
echo "[Finished installing hyprland configuration packages]"

$AUR_MANAGER -S gparted xorg-xhost ncdu dysk pacman-contrib --noconfirm --needed
echo "[Finished installing disk and cache management packages]"

$AUR_MANAGER -S pacseek reflector --noconfirm --needed
echo "[Finished installing package management tools]"

$AUR_MANAGER -S kitty zsh oh-my-posh-bin bash-completion \
   	zsh-completions fastfetch python-pywal postgresql --noconfirm --needed
echo "[Finished installing shell configuration packages]"

# Import keys required to install the Tor browser
gpg --keyserver hkps://keys.openpgp.org --recv-keys EF6E286DDA85EA2A4BA7DE684E2C6E8793298290

$AUR_MANAGER -S networkmanager tor tor-browser-bin wireshark-cli \
    wireshark-qt zed power-profiles-daemon brave-bin discord ghidra \
    signal-desktop --noconfirm --needed
echo "[Finished installing basic apps]"

$AUR_MANAGER -S nvidia-utils nvidia-open --noconfirm --needed
echo "[Finished installing nvidia packages]"

$AUR_MANAGER -S xdg-desktop-portal xdg-desktop-portal-hyprland xdg-desktop-portal-gtk \ --noconfirm --needed
echo "[Finished installing xdg-desktop packages]"

$AUR_MANAGER -S gtk4 papirus-icon-theme breeze noto-fonts noto-fonts-emoji libadwaita \
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

$AUR_MANAGER -S gnome-keyring kleopatra --noconfirm --needed
echo "[Successfully installed keyring and kleopatra]"

$AUR_MANAGER -S ttf-dejavu ttf-liberation noto-fonts noto-fonts-emoji ttf-font-awesome ttf-material-symbols-variable nerd-fonts --noconfirm --needed
echo "[Successfully installed fonts]"

$AUR_MANAGER -S yazi fd resvg xsel 7zip --noconfirm --needed
echo "[Successfully installed yazi]"

$AUR_MANAGER -S zig rustup dioxus-cli sccache docker docker-compose --noconfirm --needed
echo "[Successfully installed programming related stuff]"

$AUR_MANAGER -S make cmake clang sfml gdb wolfssl --noconfirm --needed
echo "[Successfully installed C\C++ related stuff]"

$AUR_MANAGER -S qemu-full virt-manager dnsmasq --noconfirm --needed
echo "[Successfully installed VM related stuff]"

$AUR_MANAGER -S wine winetricks --noconfirm --needed
echo "[Successfully installed wine]"

$AUR_MANAGER -S dioxus-cli libayatana-appindicator xdotool webkit2gtk-4.1 sqlite --noconfirm --needed
echo "[Successfully installed dioxus-cli]"

$AUR_MANAGER -S bitwarden trash-cli --noconfirm --needed
echo "[Successfully installed bitwarden]"

$AUR_MANAGER -S bind whois sequoia-sq qbittorrent --noconfirm --needed
echo "[Successfully installed networking utilities]"

# Create the hyprland directory (hypr) if it doesn't already exist
if [ ! -d "$HYPRLAND_DIR" ]; then
	mkdir "$HYPRLAND_DIR"
	echo "Created local hyprland directory at $HYPRLAND_DIR"
else
	echo "Found existing local hyprland directory at $HYPRLAND_DIR"
fi
# Create the waybar directory if doesn't already exist
if [ ! -d "$WAYBAR_DIR" ]; then
	mkdir "$WAYBAR_DIR"
	echo "Created local waybar directory at $WAYBAR_DIR"
else
	echo "Found existing local waybar directory at $WAYBAR_DIR"
fi
# Create the wlogout directory if doesn't already exist
if [ ! -d "$WLOGOUT_DIR" ]; then
	mkdir "$WLOGOUT_DIR"
	echo "Created local wlogout directory at $WLOGOUT_DIR"
else
	echo "Found existing local wlogout directory at $WLOGOUT_DIR"
fi
# Create the kitty directory if doesn't already exist
if [ ! -d "$KITTY_DIR" ]; then
	mkdir "$KITTY_DIR"
	echo "Created local kitty directory at $KITTY_DIR"
else
	echo "Found existing local kitty directory at $KITTY_DIR"
fi
# Create the fastfetch shell config directory if doesn't already exist
if [ ! -d "$SHELL_FASTFETCH_DIR" ]; then
	mkdir "$SHELL_FASTFETCH_DIR"
	echo "Created local fastfetch shell config directory at $SHELL_FASTFETCH_DIR"
else
	echo "Found existing local fastfetch shell config directory at $SHELL_FASTFETCH_DIR"
fi
# Create the waypaper directory if doesn't already exist
if [ ! -d "$WAYPAPER_DIR" ]; then
	mkdir "$WAYPAPER_DIR"
	echo "Created local waypaper directory at $WAYPAPER_DIR"
else
	echo "Found existing local waypaper directory at $WAYPAPER_DIR"
fi
# Create the neovim directory if it doesn't already exist
if [ ! -d "$NVIM_DIR" ]; then
	mkdir "$NVIM_DIR"
	echo "Created neovim directory at $NVIM_DIR"
else
	echo "Found existing neovim directory at $NVIM_DIR"
fi
# Create the tmux config directory if it doesn't already exist
if [ ! -d "$TMUX_DIR" ]; then
	mkdir "$TMUX_DIR"
	echo "Created tmux directory at $TMUX_DIR"
else
	echo "Found existing tmux directory at $TMUX_DIR"
fi
# Create the nwg-dock config directory if it doesn't already exist
if [ ! -d "$NWG_DOCK_DIR" ]; then
	mkdir "$NWG_DOCK_DIR"
	echo "Created nwg-dock directory at $NWG_DOCK_DIR"
else
	echo "Found existing nwg-dock directory at $NWG_DOCK_DIR"
fi
# Create the gtk themes directory if it doesn't already exist
if [ ! -d "$GTK_THEMES_DIR" ]; then
	mkdir "$GTK_THEMES_DIR"
	echo "Created gtk directory at $GTK_THEMES_DIR"
else
	echo "Found existing gtk directory at $GTK_THEMES_DIR"
fi
# Create the yazi config directory if it doesn't already exist
if [ ! -d "$YAZI_DIR" ]; then
	mkdir "$YAZI_DIR"
	echo "Created yazi directory at $YAZI_DIR"
else
	echo "Found existing yazi directory at $YAZI_DIR"
fi
# Create the cargo config directory if it doesn't already exist
if [ ! -d "$CARGO_DIR" ]; then
	mkdir "$CARGO_DIR"
	echo "Created cargo directory at $CARGO_DIR"
else
	echo "Found existing cargo directory at $CARGO_DIR"
fi
# Copy the hyprland configs to the hyprland directory on the user's device
cp $CURRENT_DIR/confs/hyprland_confs/*.conf "$HYPRLAND_DIR" -v
# Copy the hyprland configs to the hyprland config directory on the user's device
cp $CURRENT_DIR/confs/hyprland_confs/conf "$HYPRLAND_DIR" -r -v
# # Copy hyprland scripts directory to user's hyprland config directory
cp $CURRENT_DIR/scripts "$HYPRLAND_DIR" -r -v
# Copy the waybar configs to the waybar config directory on the user's device
cp $CURRENT_DIR/confs/waybar_confs/*.jsonc "$WAYBAR_DIR" -v
cp $CURRENT_DIR/confs/waybar_confs/*.css "$WAYBAR_DIR" -v
# Copy the wlogout configs to the wlogout config directory on the user's device
cp $CURRENT_DIR/confs/wlogout_confs/*.css "$WLOGOUT_DIR" -v
cp $CURRENT_DIR/confs/wlogout_confs/layout "$WLOGOUT_DIR" -v
# Copy the kitty configs to the kitty config directory on the user's device
cp $CURRENT_DIR/confs/terminal_conf/kitty/*.conf "$KITTY_DIR" -v
# Copy the bash config file to the user's .bashrc file
cp $CURRENT_DIR/confs/terminal_conf/shells/bashrc/bash_conf ~/.bashrc -v
# Copy the zsh config file to the user's .zshrc file
cp $CURRENT_DIR/confs/terminal_conf/shells/zshrc/zsh_conf ~/.zshrc -v
# Copy the fastfetch shell config to the fastfetch shell config directory on the user's device
cp $CURRENT_DIR/confs/terminal_conf/fast_fetch_conf/default.* "$SHELL_FASTFETCH_DIR" -v
# Copy default wallpaper directory with default background to user's directory
cp $CURRENT_DIR/wallpaper/ ~/ -r -v
# Copy waypaper config to user's wallpaper directory
cp $CURRENT_DIR/confs/waypaper_conf/config.ini "$WAYPAPER_DIR" -v
# Copy neovim config file to the user's neovim config directory
cp $CURRENT_DIR/confs/nvim_confs/init.lua "$NVIM_DIR" -v
# Copy neovim lua config files to the user's neovim lua config directory
cp $CURRENT_DIR/confs/nvim_confs/lua "$NVIM_DIR" -r -v
# Copy tmux config files to the user's tmux config directory
cp $CURRENT_DIR/confs/tmux_confs/*.conf "$TMUX_DIR" -v
# Copy nwg-dock config files to the user's nwg-dock config directory
cp $CURRENT_DIR/confs/nwg_dock_conf/*.css "$NWG_DOCK_DIR" -v
# Copy yazi config files to the user's yazi config directory
cp $CURRENT_DIR/confs/yazi_conf/*.toml "$YAZI_DIR" -v
# Copy cargo config files to the user's cargo config directory
cp $CURRENT_DIR/confs/cargo_conf/*.toml "$CARGO_DIR" -v
#Setup rustup
rustup toolchain install stable
export RUSTC_WRAPPER=sccache
rustup component add rust-analyzer
rustup component add rust-src
# Configure luarocks to use the user directory by default for lua package management
luarocks config local_by_default true
luarocks install stdlib --local
# Install oh-my-posh font
oh-my-posh font install JetBrainsMono
# Set shell color scheme according to default wallpaper
wal -i ~/wallpaper/default.jpg
# Display the default wallpaper
waypaper --wallpaper ~/wallpaper/default.jpg
# Add current user to wireshark group (to allow running wireshark in promiscuous mode)
sudo usermod -aG wireshark $USER
# Enable paccache
sudo systemctl enable paccache.timer
sudo systemctl start paccache.timer
# Enable libvirtd
sudo systemctl enable --now libvirtd
sudo usermod -aG libvirt $USER
# Clear old logs
sudo journalctl --vacuum-size=100M
sudo journalctl --vacuum-time=1week
# Update xdg directories
xdg-user-dirs-update
# Start SSH agent for gnome keyring
#systemctl --user enable gcr-ssh-agent.socket
#export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/gcr/ssh
eval `ssh-agent -s`
## TODO: Add command to receive +user input for countries to receive mirrors from,
## Details:
##   - Check validity of user input
##   - If there are countries for reflector in /etc/xdg/reflector/reflector.conf, use them instead of
##     prompting the user for input
##   - Replace old config with the new one
reflector --list-countries
read -p "Enter the countries you want to receive mirrors from (comma-separated): " -r countries
if [ -n "$countries" ]; then
    echo "Countries: $countries"
    sudo sed -i '21s/.*/--country '"$countries"'/' /etc/xdg/reflector/reflector.conf
    sudo systemctl enable --now reflector.timer
else
    echo "[No countries provided, skipping reflector setup]"
fi
# Allow chvt without sudo, to allow hyprshutdown to properly work
echo "$USER ALL=(ALL) NOPASSWD: /usr/bin/chvt" | sudo tee /etc/sudoers.d/chvt
sudo chmod 440 /etc/sudoers.d/chvt
# Create the hyprland directory (hypr) if it doesn't already exist
if [ "$SHELL" != $(which zsh) ]; then
    sudo chsh -s $(which zsh) $USER
    echo "[Changed the default shell from $SHELL=>$(which zsh)]"
else
	echo "[The default shell is zsh]"
fi
# Dark mode so you won't become blind ;)
gsettings set org.gnome.desktop.interface color-scheme prefer-dark
# Check if the user loves candy :)
sed -n '/ILoveCandy/q 0;$q 1' /etc/pacman.conf
if [ "$?" != 0 ]; then
    sudo sed -i '/Misc options/a ILoveCandy' /etc/pacman.conf
    echo "[NOW YOU HAVE CANDY, HURRAY!!]"
else
    echo "[I LOVE CANDY]"
fi
echo "[Please restart to allow all changes to take effect]"
