HOMELAB_HOSTNAME="homelab"
DOTFILES_DIR="$HOME/.dotfiles/"

source "$DOTFILES_DIR/.bashrc_main"

if [ "$HOSTNAME" = "$HOMELAB_HOSTNAME" ]; then
    source "$DOTFILES_DIR/.bashrc_homelab"
fi
