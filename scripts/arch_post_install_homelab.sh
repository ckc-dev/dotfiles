#!/bin/bash
# This script installs and sets up a variety of packages and configurations on a fresh Arch Linux installation.
# This is aimed at a homelab server Arch setup, and presumes that a root user is being used.

# Exit immediately if any command exits with a non-zero status or an unset variable is used.
set -eu

DOTFILES_DIR="$HOME/.dotfiles/scripts"

read -p "This script will install packages and modify system configurations. Are you sure you want to continue? (y/n) " -r
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 1
fi

# Install packages.
packages=(
    docker
    docker-compose
    ntfs-3g
    openssh
    python
    python-pip
    udiskie
    udisks2
)

printf "\nSetting up dotfiles...\n"
bash $SCRIPTS_DIR/setup_dotfiles.sh

printf "\nInstalling packages...\n"
pacman -Syu "${packages[@]}"

printf "\Enabling services...\n"
systemctl enable sshd
systemctl enable docker

systemctl start sshd
systemctl start docker
