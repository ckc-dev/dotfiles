#
# ~/.bashrc
#

# If not running interactively, don't do anything.
[[ $- != *i* ]] && return

# Prompt.
PS1='[\u@\h \W]\$ '

# Fix some issues with GPG2.
export GPG_TTY=$(tty)

# Control .dotfiles git repository.
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# Display colors with "ls" command.
alias ls='ls --color=auto'

# Detailed file listing.
alias ll='ls -ashl'

# Reboot directly to Windows. (source: https://unix.stackexchange.com/a/112284)
reboot_to_windows ()
{
    windows_title=$(sudo grep -i windows /boot/grub/grub.cfg | cut -d "'" -f 2)
    sudo grub-reboot "$windows_title" && sudo reboot
}
alias reboot-to-windows='reboot_to_windows'

# Create and load a Python virtual environment.
alias ve='python -m venv ./venv'
alias va='source venv/bin/activate'

# Move up directories.
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'

# Load git completion script. (source: https://github.com/git/git/blob/master/contrib/completion/git-completion.bash)
. ~/.bash/git-completion.bash

