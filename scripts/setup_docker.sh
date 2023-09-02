#!/bin/bash

# Check if Docker is already installed.
if ! command -v docker &>/dev/null; then
    echo "Docker is not installed. Installing Docker..."
    sudo pacman -S docker
fi

# Start Docker service.
sudo systemctl enable docker
sudo systemctl start docker

# Add user to the docker group and activate changes.
sudo usermod -aG docker $USER
newgrp docker
