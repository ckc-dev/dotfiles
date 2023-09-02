#!/bin/bash

echo "This script will disable the system speaker beeps."
read -p "Do you want to proceed? (y/n): " response

if [[ $response =~ ^[Yy]$ ]]; then
    # Create /etc/modprobe.d folder if it doesn't exist.
    sudo mkdir -p /etc/modprobe.d

    # Create nobeep.conf file in /etc/modprobe.d to disable system speaker.
    echo "blacklist pcspkr" | sudo tee /etc/modprobe.d/nobeep.conf >/dev/null
    echo "System speaker beep has been disabled. You may need to reboot for changes to take effect."
fi
