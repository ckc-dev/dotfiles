#!/bin/bash
# This script installs and sets up a variety of packages and configurations on a fresh Arch Linux installation.
# This is aimed at a homelab server Arch setup.

# Exit immediately if any command exits with a non-zero status or an unset variable is used.
set -eu

SCRIPTS_DIR="$HOME/.dotfiles/scripts"

read -p "This script will install packages and modify system configurations. Are you sure you want to continue? (y/n) " -r
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  exit 1
fi

official_packages=(
  docker
  docker-compose
  ntfs-3g
  openssh
  python
  python-pip
  ranger
  udiskie
  udisks2
)

printf "\nSetting up dotfiles...\n"
bash $SCRIPTS_DIR/setup_dotfiles.sh

printf "\nInstalling packages...\n"
sudo pacman -Syu "${official_packages[@]}"

printf "\nEnabling services...\n"
sudo systemctl enable sshd
sudo systemctl enable docker

sudo systemctl start sshd
sudo systemctl start docker

printf "\nSetting up docker group...\n"
sudo groupadd docker
sudo usermod -aG docker ${USER}
newgrp docker
