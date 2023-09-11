#!/bin/bash
# This script will generate new GPG and SSH keys and override the '$HOME/.gitconfig-user' file.

# Exit immediately if any command exits with a non-zero status or an unset variable is used.
set -eu

# Constants:
PUBLIC_NAME="ckc-dev"
PUBLIC_EMAIL="70550797+ckc-dev@users.noreply.github.com"

read -p "This script will modify system configurations. Are you sure you want to continue? (y/n) " -r
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  exit 1
fi

read -s -p "Enter your password:" gpg_key_passphrase
printf "\n"

gpg_key_parameters=$(mktemp)

cat <<EOF > "$gpg_key_parameters"
     %echo Generating GPG key. This key will be valid for 6 months.
     Key-Type: RSA
     Key-Length: 4096
     Subkey-Type: RSA
     Subkey-Length: 4096
     Name-Real: $PUBLIC_NAME
     Name-Email: $PUBLIC_EMAIL
     Expire-Date: 6m
     Passphrase: $gpg_key_passphrase
     %commit
     %echo Key successfully generated.
EOF

gpg --batch --generate-key "$gpg_key_parameters"

rm "$gpg_key_parameters"

gpg_key_id=$(gpg --list-signatures --with-colons | grep 'sig' | grep $PUBLIC_NAME | head -n 1 | cut -d':' -f5)

printf "Generating '.gitconfig-user' file...\n"
printf "[user]\n\tsigningkey = $gpg_key_id\n" > $HOME/.gitconfig-user

printf "Printing GPG key armor...\n"
gpg --armor --export $gpg_key_id
printf "Remember to add this to your GitHub account!\n"
read -n 1 -srp "Once done, press any key to continue."
printf "\n"

printf "\nGenerating SSH key...\n"
ssh-keygen -o -t ed25519 -C "$PUBLIC_EMAIL"

printf "Starting SSH agent...\n"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

printf "Printing public SSH key...\n"
cat ~/.ssh/id_ed25519.pub
printf "Remember to add this to your GitHub account!\n"
