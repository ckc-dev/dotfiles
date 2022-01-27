#!/bin/bash

# NOTE: THIS SCRIPT IS MEANT FOR FRESH INSTALLS.
# This script will generate new GPG and SSH keys and
# override the '$HOME/.gitconfig-user' file, make sure
# this is what you want to do.

set -e

printf "Step 1: Generating GPG key...\n"
gpg --full-generate-key
gpg --list-secret-keys --keyid-format=long

read -p "Enter the generated key ID: " GPG_KEY_ID

printf "Generating '.gitconfig-user' file...\n"
printf "[user]\n\tsigningkey = $GPG_KEY_ID\n" > $HOME/.gitconfig-user

printf "Printing GPG key armor...\n"
gpg --armor --export $GPG_KEY_ID
printf "Remember to add this to your GitHub account!\n"
read -n 1 -srp "Once done, press any key to continue."
printf "\n"

printf "\nStep 2: Generating SSH key...\n"
read -p "Enter your public GitHub e-mail: " PUBLIC_GITHUB_EMAIL
printf "Remember to use at least 4096 bits!\n"
ssh-keygen -t ed25519 -C "$PUBLIC_GITHUB_EMAIL"

printf "Starting SSH agent...\n"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

printf "Printing public SSH key...\n"
cat ~/.ssh/id_ed25519.pub
printf "Remember to add this to your GitHub account!\n"
read -n 1 -srp "Once done, press any key to continue."
printf "\n"

printf "\nAll done!\n"
