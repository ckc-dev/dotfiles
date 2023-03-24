#!/bin/bash
# This script sets up a variety of sensible configurations for a Lenovo S145 on a fresh Arch Linux installation.

# Exit immediately if any command exits with a non-zero status or an unset variable is used.
set -eu

read -p "This script will modify system configurations. Are you sure you want to continue? (y/n) " -r
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  exit 1
fi

dotfiles_url="https://github.com/ckc-dev/dotfiles.git"

printf "Cloning s145 configuration files into a temporary folder...\n"
mkdir /tmp/s145/
git clone $dotfiles_url /tmp/s145/ -b lenovo-s145

printf "Copying s145 configuration files...\n"
sudo cp -r /tmp/s145/etc/* /etc/

printf "Deleting temporary folder used for configuration files...\n"
rm -rf /tmp/s145/
