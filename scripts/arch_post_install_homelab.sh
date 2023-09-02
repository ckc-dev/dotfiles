#!/bin/bash
# This script installs and sets up a variety of packages and configurations on a fresh Arch Linux installation.

set -eu

packages=(
    ssh
    docker
    docker-compose
)

pacman -Syu "${packages[@]}"
