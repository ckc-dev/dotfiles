#!/bin/bash
# This script sets up a systemd timer to periodically run the Nextcloud occ files:scan command.

NEXTCLOUD_UTILS_LOCATION=$HOME/.dotfiles/.containers/nextcloud/utils

# Link service and timer files.
sudo ln -s ${NEXTCLOUD_UTILS_LOCATION}/nextcloud-scan-files.service /etc/systemd/system/
sudo ln -s ${NEXTCLOUD_UTILS_LOCATION}/nextcloud-scan-files.timer /etc/systemd/system/

# Ensure that systemd reads the newly linked files.
sudo systemctl daemon-reload

# Start and enable the timer.
sudo systemctl start nextcloud-scan-files.timer
sudo systemctl enable nextcloud-scan-files.timer
