#!/bin/bash

# Exit immediately if any command exits with a non-zero status or an unset variable is used.
set -eu

dotfiles_dir="$HOME/.dotfiles"
containers_dir=".containers"
target_dir="$HOME/$containers_dir"
verbose=false

# Docker doesn't exactly love soft links...
create_hard_links() {
    local source_dir="$1"
    local target_dir="$2"

    for item in "$source_dir"/*; do
        local base_name="$(basename "$item")"
        local target_item="$target_dir/$base_name"

        if [ -e "$item" ]; then
            if [ -d "$item" ]; then
                if [ ! -d "$target_item" ]; then
                    mkdir -p "$target_item"
                    if [ "$verbose" = true ]; then
                        echo "Created directory: $target_item"
                    fi
                else
                    if [ "$verbose" = true ]; then
                        echo "Directory already exists: $target_item"
                    fi
                fi
                create_hard_links "$item" "$target_item"
            elif [ -f "$item" ]; then
                if [ ! -e "$target_item" ]; then
                    ln "$item" "$target_item"
                    if [ "$verbose" = true ]; then
                        echo "Created hard link for: $item"
                    fi
                else
                    if [ "$verbose" = true ]; then
                        echo "Hard link already exists for: $item"
                    fi
                fi
            fi
        elif [ "$verbose" = true ]; then
            echo "Skipping non-existent item: $item"
        fi
    done
}

while [[ $# -gt 0 ]]; do
    case "$1" in
    -v | --verbose)
        verbose=true
        shift
        ;;
    *)
        echo "Invalid option: $1" >&2
        exit 1
        ;;
    esac
done

echo "Recreating directory structure and hard-linking files..."
create_hard_links "$dotfiles_dir/$containers_dir" "$target_dir"

echo "Done!"
