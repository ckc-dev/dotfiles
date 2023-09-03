#!/bin/bash
# This script installs and sets up a variety of packages and configurations on a fresh Arch Linux installation.

set -eu

packages=(
    docker
    docker-compose
    openssh
)

pacman -Syu "${packages[@]}"
