#!/bin/bash

# NOTE: THIS SCRIPT IS MEANT FOR FRESH ARCH LINUX INSTALLS.
# This script will install programs and override configuration
# files, make sure this is what you want to do.

set -e

printf "Step 1: Enabling multilib repositiories on pacman...\n"
sudo bash -c "printf '\n\n[multilib]\nInclude = /etc/pacman.d/mirrorlist\n' >> /etc/pacman.conf"

printf "\nStep 2: Installing packages...\n"
sudo pacman -Syu acpilight base-devel darktable firefox gcc gimp i3-gaps i3status nomacs noto-fonts noto-fonts-cjk noto-fonts-emoji ntfs-3g openssh pavucontrol pulseaudio python python-pip rofi rxvt-unicode steam vlc xorg-server xorg-xinit xorg-xsetroot hdparm pcmanfm-gtk3 flameshot android-file-transfer playerctl qbittorrent dotnet-runtime dotnet-sdk udisks udiskie

printf "\nStep 3: Setting up dotfiles...\n"
bash setup_dotfiles.sh

printf "Generating configuration files...\n"
python $HOME/.dotfiles-pyconfig/pytheme.py -x termux-colors

printf "\nStep 4: Installing AUR helper...\n"
mkdir /tmp/aur/
git clone https://aur.archlinux.org/paru.git /tmp/aur/
cd /tmp/aur/
makepkg -si
cd -
rm -rf /tmp/aur/

printf "\nStep 5: Installing AUR packages...\n"
paru visual-studio-code-bin rider

printf "\nAll done!\n"
