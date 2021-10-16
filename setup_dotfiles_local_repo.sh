#!/bin/bash

# NOTE: THIS SCIPRT IS MEANT FOR FRESH ISNTALLS.
# This script will override your current configuration files, make
# sure this is what you want to do.

set -e

printf '\nCREATING ".gitgnore"...\n'
printf '.dotfiles' >> $HOME/.gitignore

printf '\nRESPOSITORY URL: '
read REPOSITORY_URL

printf '\nCLONING REPOSITORY...\n'
git clone --bare $REPOSITORY_URL $HOME/.dotfiles

printf '\nCHECKING OUT REPOSITORY CONTENTS...\n'
git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME checkout --force

printf '\nCONFIGURING REPOSITORY TO NOT SHOW UNTRACKED FILES...\n'
git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME config --local status.showUntrackedFiles no

printf '\nDELETING ".gitignore"...\n'
rm $HOME/.gitignore

printf '\nDONE!\n'
