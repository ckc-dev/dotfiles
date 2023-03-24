#!/bin/bash
# This script sets up a bare dotfiles repository.

# Exit immediately if any command exits with a non-zero status or an unset variable is used.
set -eu

repository_url_https="https://github.com/ckc-dev/dotfiles.git"
repository_url_ssh="git@github.com:ckc-dev/dotfiles.git"

printf "Creating '.gitgnore'...\n"
printf ".dotfiles" >> $HOME/.gitignore

printf "Cloning repository...\n"
git clone --bare $repository_url_https $HOME/.dotfiles

printf "Changing repository from HTTPS to SSH...\n"
git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME remote set-url origin $repository_url_ssh

printf "Configuring repository...\n"
git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME checkout --force
git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME config --local status.showUntrackedFiles no

printf "Deleting '.gitignore'...\n"
rm $HOME/.gitignore
