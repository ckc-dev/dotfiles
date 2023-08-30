#!/bin/bash
# This script sets up a bare dotfiles repository.

# Exit immediately if any command exits with a non-zero status or an unset variable is used.
set -eu

repository_url_https="https://github.com/ckc-dev/dotfiles.git"
repository_url_ssh="git@github.com:ckc-dev/dotfiles.git"
dotfiles_path="$dotfiles_path"

printf "Cloning repository...\n"
git clone $repository_url_https $dotfiles_path

printf "Changing repository from HTTPS to SSH...\n"
git --git-dir=$dotfiles_path/.git/ --work-tree=$HOME remote set-url origin $repository_url_ssh

printf "Configuring repository...\n"
git --git-dir=$dotfiles_path/.git/ --work-tree=$dotfiles_path/ checkout --force
git --git-dir=$dotfiles_path/.git/ --work-tree=$dotfiles_path/ config --local status.showUntrackedFiles no
