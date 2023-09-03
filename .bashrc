HOMELAB_HOSTNAME="homelab"
BASH_SCRIPTS_DIR="$HOME/.dotfiles/bash"

source "$BASH_SCRIPTS_DIR/.bashrc_main"

if [ "$HOSTNAME" = "$HOMELAB_HOSTNAME" ]; then
    source "$BASH_SCRIPTS_DIR/.bashrc_homelab"
fi
