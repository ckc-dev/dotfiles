#!/bin/bash
# This script installs and sets up a variety of packages and configurations on a fresh Arch Linux installation.

# Exit immediately if any command exits with a non-zero status or an unset variable is used.
set -eu

read -p "This script will install packages and modify system configurations. Are you sure you want to continue? (y/n) " -r
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  exit 1
fi

official_packages=(
  acpilight
  android-file-transfer
  base-devel
  darktable
  firefox
  flameshot
  gcc
  gimp
  hdparm
  i3-gaps
  i3status
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
  rofi
  rsync
  rxvt-unicode
  steam
  udiskie
  udisks2
  vlc
  xorg-server
  xorg-xinit
  xorg-xsetroot
)

aur_packages=(
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
pacman -Syu "${official_packages[@]}"

printf "\nSetting up dotfiles...\n"
bash setup_dotfiles.sh

printf "\nGenerating configuration files...\n"
python "$HOME/.dotfiles/dotsmith/dotsmith.py" -x termux-colors

printf "\nInstalling AUR helper...\n"
sudo mount -o remount,size=2G /tmp
mkdir /tmp/aur/
git clone https://aur.archlinux.org/paru.git /tmp/aur/
cd /tmp/aur/
makepkg -si
cd -
rm -rf /tmp/aur/
sudo mount -o remount,size=auto /tmp

printf "\nInstalling AUR packages...\n"
paru "${aur_packages[@]}"
