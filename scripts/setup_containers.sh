#!/bin/bash

# Exit immediately if any command exits with a non-zero status or an unset variable is used.
set -eu

dotfiles_dir="$HOME/.dotfiles"
containers_dir=".containers"
target_dir="$HOME/$containers_dir"
verbose=false

create_hard_links() {
    local source_dir="$1"
    local target_dir="$2"

    for item in "$source_dir"/*; do
        local base_name="$(basename "$item")"

        if [ -e "$item" ]; then
            if [ -d "$item" ]; then
                mkdir -p "$target_dir/$base_name"
                if [ "$verbose" = true ]; then
                    echo "Created directory: $target_dir/$base_name"
                fi
                create_hard_links "$item" "$target_dir/$base_name"
            elif [ -f "$item" ]; then
                ln "$item" "$target_dir/$base_name"
                if [ "$verbose" = true ]; then
                    echo "Created hard link for: $item"
                fi
            fi
        elif [ "$verbose" = true ]; then
            echo "Skipping non-existent item: $item"
        fi
    done
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        -v|--verbose)
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
