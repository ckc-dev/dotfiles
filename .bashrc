#
# ~/.bashrc
#

# If not running interactively, don't do anything.
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

# Fix some issues with GPG2.
export GPG_TTY=$(tty)

# Dotfiles git alias.
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# List files alias.
alias ll='ls -ashl'

# Reboot directly to Windows. (source: https://unix.stackexchange.com/a/112284)
reboot_to_windows ()
{
    windows_title=$(grep -i windows /boot/grub/grub.cfg | cut -d "'" -f 2)
    sudo grub-reboot "$windows_title" && sudo reboot
}
alias reboot-to-windows='reboot_to_windows'

