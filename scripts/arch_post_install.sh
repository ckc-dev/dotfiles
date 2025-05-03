#!/bin/bash
# This script installs and sets up a variety of packages and configurations on a fresh Arch Linux installation.

# Exit immediately if any command exits with a non-zero status or an unset variable is used.
set -eu

SCRIPTS_DIR="$HOME/.dotfiles/scripts"

read -p "This script will install packages and modify system configurations. Are you sure you want to continue? (y/n) " -r
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  exit 1
fi

official_packages=(
  7zip
  acpilight
  android-file-transfer
  atool
  baobab
  base-devel
  bleachbit
  bluez
  bluez-utils
  chromium
  darktable
  ddrescue
  dhcpcd
  docker
  docker-compose
  dos2unix
  dosfstools
  dvdbackup
  exfat-utils
  ffmpegthumbnailer
  filezilla
  firefox
  flameshot
  gcc
  gimp
  gnome-disk-utility
  gnome-system-monitor
  gsmartcontrol
  gst-libav
  gst-plugins-bad
  gst-plugins-base
  gst-plugins-good
  gst-plugins-ugly
  gthumb
  gvfs-mtp
  handbrake
  hdparm
  hsetroot
  htop
  i3-wm
  i3status
  inkscape
  kdenlive
  less
  libreoffice-fresh
  meld
  mkvtoolnix-cli
  nautilus
  nautilus-image-converter
  net-tools
  nfs-utils
  noto-fonts
  noto-fonts-cjk
  noto-fonts-emoji
  ntfs-3g
  openssh
  pavucontrol
  picom
  playerctl
  polkit-gnome
  pulseaudio
  python
  python-pip
  ranger
  rofi
  rsync
  rxvt-unicode
  ttf-fira-code
  udiskie
  udisks2
  unrar
  unzip
  usbutils
  vim
  vlc
  xorg-server
  xorg-xinit
  zerotier-one
)

aur_packages=(
  code-nautilus-git
  cryptomator
  czkawka-gui-bin
  f3
  nautilus-admin-gtk4
  nautilus-hide
  nautilus-launch
  nautilus-metadata-editor
  nautilus-open-any-terminal
  nwipe
  simplest-file-renamer-bin
  visual-studio-code-bin
)

printf "Enabling multilib repositories on pacman...\n"
if grep -q "#\[multilib\]" /etc/pacman.conf; then
  sudo sed -i '/#\?\[multilib\]/{s/^#//;n;s/^#//}' /etc/pacman.conf
  printf "Multilib repositories have been uncommented and enabled.\n"
elif grep -q "\[multilib\]" /etc/pacman.conf; then
  printf "Multilib repositories are already enabled.\n"
else
  sudo bash -c "printf '\n\n[multilib]\nInclude = /etc/pacman.d/mirrorlist\n' >> /etc/pacman.conf"
  printf "Multilib repositories have been enabled.\n"
fi

printf "\nInstalling packages...\n"
sudo pacman -Syu "${official_packages[@]}"

printf "\nSetting up dotfiles...\n"
if [ ! -d "$HOME/.dotfiles" ]; then
    bash "$SCRIPTS_DIR/setup_dotfiles.sh"
fi

printf "\nLinking configuration files...\n"
mkdir -p "$HOME/.local/share/"
ln -sf "$HOME/.dotfiles/.local/share/applications/" "$HOME/.local/share"
ln -sf "$HOME/.dotfiles/bash" "$HOME"
ln -sf "$HOME/.dotfiles/.bashrc" "$HOME"
ln -sf "$HOME/.dotfiles/.bash_profile" "$HOME"
ln -sf "$HOME/.dotfiles/.gitconfig" "$HOME"
ln -sf "$HOME/.dotfiles/.xinitrc" "$HOME"
ln -sf "$HOME/.dotfiles/.Xresources" "$HOME"
sudo mkdir -p /etc/X11/

if [ -d "/etc/X11/xorg.conf.d" ]; then
    if [ "$(ls -A /etc/X11/xorg.conf.d)" ]; then
        # If not empty, copy to source directory.
        sudo cp -r /etc/X11/xorg.conf.d/* "$HOME/.dotfiles/etc/X11/xorg.conf.d/"
    fi
    sudo rm -r /etc/X11/xorg.conf.d
fi

sudo ln -sf "$HOME/.dotfiles/etc/X11/xorg.conf.d/" /etc/X11/
sudo mkdir -p /etc/modprobe.d/
sudo ln -sf .dotfiles/etc/modprobe.d/nobeep.conf /etc/modprobe.d/

printf "\nGenerating configuration files...\n"
python "$HOME/.dotfiles/dotsmith/dotsmith.py" -x termux-colors

printf "\nInstalling AUR helper...\n"
mkdir "$HOME/temporary_aur_install_directory/"
git clone https://aur.archlinux.org/paru.git "$HOME/temporary_aur_install_directory/"
cd "$HOME/temporary_aur_install_directory/"
makepkg -si
cd -
rm -rf "$HOME/temporary_aur_install_directory/"

printf "\nInstalling AUR packages...\n"
paru "${aur_packages[@]}"
