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
  acpilight
  android-file-transfer
  atool
  baobab
  base-devel
  bleachbit
  darktable
  ddrescure
  docker
  docker-compose
  dvdbackup
  exfat-utils
  filezilla
  firefox
  flameshot
  gcc
  gimp
  gnome-disk-utility
  gsmartcontrol
  hdparm
  i3-gaps
  i3status
  kdenlive
  kitty
  noto-fonts
  noto-fonts-cjk
  noto-fonts-emoji
  ntfs-3g
  openssh
  pavucontrol
  pcmanfm-gtk3
  playerctl
  pulseaudio
  python
  python-pip
  qbittorrent
  ranger
  rofi
  rsync
  steam
  ttf-fira-code
  udiskie
  udisks2
  unzip
  vim
  vlc
  xorg-server
  xorg-xinit
  xorg-xsetroot
)

aur_packages=(
  cryptomator
  czkawka-gui-bin
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
bash $SCRIPTS_DIR/setup_dotfiles.sh

printf "\nLinking configuration files...\n"
ln -sf "$HOME/.dotfiles/.local/share/applications" "$HOME/.local/share"
ln -sf "$HOME/.dotfiles/bash" "$HOME"
ln -sf "$HOME/.dotfiles/.bashrc" "$HOME"
ln -sf "$HOME/.dotfiles/.bash_profile" "$HOME"
ln -sf "$HOME/.dotfiles/.gitconfig" "$HOME"
ln -sf "$HOME/.dotfiles/.xinitrc" "$HOME"
ln -sf "$HOME/.dotfiles/.Xresources" "$HOME"
sudo ln -sf .dotfiles/etc/X11/xorg.conf.d/ /etc/X11/
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
