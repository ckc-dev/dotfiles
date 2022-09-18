#!/bin/bash

# NOTE: THIS SCRIPT IS MEANT FOR FRESH ARCH LINUX INSTALLS.
# This will override configurations with sensible (perhaps a
# bit biased) values for a Lenovo s145 notebook.

set -e

DOTFILES_URI="https://github.com/ckc-dev/dotfiles.git"

printf "Cloning s145 configuration files into a temporary folder...\n"
mkdir /tmp/s145/
git clone $DOTFILES_URI /tmp/s145/ -b lenovo-s145

printf "Copying s145 configuration files...\n"
sudo cp -r /tmp/s145/etc/* /etc/

printf "Deleting temporary folder used for configuration files..."
rm -rf /tmp/s145/
