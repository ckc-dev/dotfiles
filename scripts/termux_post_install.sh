#!/bin/bash
# This script installs and sets up a variety of packages and configurations on a fresh Termux installation.

# Exit immediately if any command exits with a non-zero status or an unset variable is used.
set -eu

SCRIPTS_DIR="$HOME/.dotfiles/scripts"

read -p "This script will install packages and modify system configurations. Are you sure you want to continue? (y/n) " -r
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  exit 1
fi

packages=(
  gnupg
  openssh
  python
  ranger
  vim
  wget
)

printf "\nCreating temporary directory...\n"
mkdir -p $HOME/.tmp/
TEMP_DIR=$HOME/.tmp/

printf "\nSetting up storage...\n"
termux-setup-storage

printf "\nUninstalling packages...\n"
pkg uninstall nano -y

printf "\nInstalling packages...\n"
pkg upgrade -y
pkg install "${packages}" -y
pkg clean

printf "\nSetting up font...\n"
FONT_DESTINATION=$HOME/.termux/font.ttf
FONT_SOURCE_LOCATION=variable_ttf/FiraCode-VF.ttf
GITHUB_API_FONT_REPO_LATEST_RELEASE_URL=https://api.github.com/repos/tonsky/FiraCode/releases/latest
DOWNLOAD_URL=$(curl $GITHUB_API_FONT_REPO_LATEST_RELEASE_URL\
  | grep "browser_download_url.*.zip"\
  | cut -d : -f 2,3\
  | tr -d \"
)
wget -O $TEMP_DIR/font.zip $DOWNLOAD_URL
unzip $TEMP_DIR/font.zip -d $TEMP_DIR/font/
cp $TEMP_DIR/font/$FONT_SOURCE_LOCATION $FONT_DESTINATION

printf "\nSetting up dotfiles...\n"
bash $SCRIPTS_DIR/setup_dotfiles.sh

printf "\nGenerating configuration files...\n"
python $HOME/.dotfiles/dotsmith/dotsmith.py termux-colors

printf "\nDeleting temporary directory...\n"
rm -rf $TEMP_DIR
