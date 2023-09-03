#!/bin/bash

dotfiles_dir="$HOME/.dotfiles"
containers_dir=".containers"
target_dir="$HOME/$containers_dir"
verbose=false

# Function to create hard links for files and directories
create_hard_links() {
    local source_dir="$1"
    local target_dir="$2"

    # Loop through the items in the source directory
    for item in "$source_dir"/*; do
        # Get the item's base name (file or directory name)
        local base_name="$(basename "$item")"

        if [ -e "$item" ]; then
            if [ -d "$item" ]; then
                # Recursively create a directory in the target location
                mkdir -p "$target_dir/$base_name"
                if [ "$verbose" = true ]; then
                    echo "Created directory: $target_dir/$base_name"
                fi
                create_hard_links "$item" "$target_dir/$base_name"
            elif [ -f "$item" ]; then
                # Create a hard link for regular files
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

# Call the function to create hard links
create_hard_links "$dotfiles_dir/$containers_dir" "$target_dir"

echo "Folder structure with hard links created."
