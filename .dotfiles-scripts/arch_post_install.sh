#!/bin/bash

# NOTE: THIS SCRIPT IS MEANT FOR FRESH INSTALLS.
# This script will install programs and override configuration
# files, make sure this is what you want to do.

set -e

printf "Step 1: Enabling multilib repositiories on pacman...\n"
sudo bash -c "printf '\n\n[multilib]\nInclude = /etc/pacman.d/mirrorlist\n' >> /etc/pacman.conf"

printf "\nStep 2: Installing packages...\n"
sudo pacman -Syu acpilight base-devel bleachbit darktable discord firefox gcc gimp git i3-gaps i3status nomacs noto-fonts noto-fonts-cjk ntfs-3g openssh pavucontrol pulseaudio python python-pip ranger rofi rxvt-unicode signal-desktop steam vim vlc xorg-server xorg-xinit xorg-xsetroot

printf "\nStep 3: Setting up dotfiles...\n"

printf "Creating '.gitgnore'...\n"
printf ".dotfiles" >> $HOME/.gitignore

read -p "Dotfiles repository URL: " REPOSITORY_URL

printf "Cloning repository...\n"
git clone --bare $REPOSITORY_URL $HOME/.dotfiles

printf "Configuring repository...\n"
git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME checkout --force
git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME config --local status.showUntrackedFiles no

printf "Deleting '.gitignore'...\n"
rm $HOME/.gitignore

printf "Generating configuration files...\n"
python $HOME/.dotfiles-pytheme/pytheme.py

printf "\nStep 4: Installing AUR helper...\n"
git clone https://aur.archlinux.org/paru.git /tmp/
cd /tmp/paru/
makepkg -si
cd -
rm -rf /tmp/paru/

printf "\nStep 5: Installing AUR packages...\n"
paru visual-studio-code-bin

printf "\nAll done!\n"
