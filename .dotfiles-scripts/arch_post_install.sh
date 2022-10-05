#!/bin/bash

# NOTE: THIS SCRIPT IS MEANT FOR FRESH ARCH LINUX INSTALLS.
# This script will install programs and override configuration
# files, make sure this is what you want to do.

set -e

REPOSITORY_URI="https://github.com/ckc-dev/dotfiles.git"
REPOSITORY_URI_SSH="git@github.com:ckc-dev/dotfiles.git"

printf "Step 1: Enabling multilib repositiories on pacman...\n"
sudo bash -c "printf '\n\n[multilib]\nInclude = /etc/pacman.d/mirrorlist\n' >> /etc/pacman.conf"

printf "\nStep 2: Installing packages...\n"
sudo pacman -Syu acpilight base-devel darktable firefox gcc gimp i3-gaps i3status nomacs noto-fonts noto-fonts-cjk noto-fonts-emoji ntfs-3g openssh pavucontrol pulseaudio python python-pip rofi rxvt-unicode steam vlc xorg-server xorg-xinit xorg-xsetroot hdparm pcmanfm-gtk3 flameshot android-file-transfer playerctl qbittorrent dotnet-runtime dotnet-sdk

printf "\nStep 3: Setting up dotfiles...\n"

printf "Creating '.gitgnore'...\n"
printf ".dotfiles" >> $HOME/.gitignore

printf "Cloning repository...\n"
git clone --bare $REPOSITORY_URI $HOME/.dotfiles

printf "Changing repository HTTPS URI to SSH...\n"
git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME remote set-url origin $REPOSITORY_URI_SSH

printf "Configuring repository...\n"
git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME checkout --force
git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME config --local status.showUntrackedFiles no

printf "Deleting '.gitignore'...\n"
rm $HOME/.gitignore

printf "Generating configuration files...\n"
python $HOME/.dotfiles-pytheme/pytheme.py

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
