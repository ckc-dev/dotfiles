#!/bin/bash
dotfiles_dir="$HOME/.dotfiles"
containers_dir=".containers"

# Create the base folder structure.
mkdir -p "$HOME/$containers_dir"

# Find all compose.yaml files in .dotfiles/.containers.
mapfile -t compose_files < <(find "$dotfiles_dir/$containers_dir" -name "compose.yaml")

# Loop through the compose files and create symbolic links.
for file in "${compose_files[@]}"; do
  source_folder=$(dirname "${file#$dotfiles_dir/$containers_dir}")
  target_folder="$HOME/$containers_dir/$source_folder"

  # Create symbolic link for compose.yaml.
  mkdir -p "$target_folder"
  ln -s "$file" "$target_folder/"

  # Create target config folder and link contents.
  config_source="$dotfiles_dir/$containers_dir/$source_folder/config"
  config_target="$target_folder/config"
  if [ -d "$config_source" ]; then
    mkdir -p "$config_target"
    find "$config_source" -maxdepth 1 ! -name "config" -exec ln -s "{}" "$config_target/" \;
  fi
done

echo "Folder structure, symbolic links, and config links created."
