#!/bin/bash
# This script will generate new GPG and SSH keys and override the '$HOME/.gitconfig-user' file.

# Exit immediately if any command exits with a non-zero status or an unset variable is used.
set -eu

read -p "This script will modify system configurations. Are you sure you want to continue? (y/n) " -r
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  exit 1
fi

public_github_email="70550797+ckc-dev@users.noreply.github.com"

printf "Generating GPG key...\n"
printf "Remember to use at least 4096 bits!\n"
gpg --full-generate-key
gpg --list-secret-keys --keyid-format=long

read -p "Enter the generated key ID: " gpg_key_id

printf "Generating '.gitconfig-user' file...\n"
printf "[user]\n\tsigningkey = $gpg_key_id\n" > $HOME/.gitconfig-user

printf "Printing GPG key armor...\n"
gpg --armor --export $gpg_key_id
printf "Remember to add this to your GitHub account!\n"
read -n 1 -srp "Once done, press any key to continue."
printf "\n"

printf "\nGenerating SSH key...\n"
ssh-keygen -o -t ed25519 -C "$public_github_email"

printf "Starting SSH agent...\n"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

printf "Printing public SSH key...\n"
cat ~/.ssh/id_ed25519.pub
printf "Remember to add this to your GitHub account!\n"
