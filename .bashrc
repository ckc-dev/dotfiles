#
# ~/.bashrc
#

# If not running interactively, don"t do anything.
[[ $- != *i* ]] && return

# Load git prompt script. (source: https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh)
. ~/.bash/git-prompt.sh
export GIT_PS1_SHOWDIRTYSTATE=1

# Prompt.
PS1='[\u@\h \W]$(__git_ps1 " (%s)")\$ '

# Fix some issues with GPG2.
export GPG_TTY=$(tty)

# Automatically cd into directories.
shopt -s autocd

# Control .dotfiles git repository.
alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"

# Display colors with "ls" command.
alias ls="ls --color=auto"

# Detailed file listing.
alias ll="ls -ashl"

# Reboot directly to Windows. (source: https://unix.stackexchange.com/a/112284)
reboot_to_windows ()
{
    windows_title=$(sudo grep -i windows /boot/grub/grub.cfg | cut -d "'" -f 2)
    sudo grub-reboot "$windows_title" && sudo reboot
}

# Create and load a Python virtual environment.
alias ve="python -m venv ./venv"
alias va="source venv/bin/activate"

# Load git completion script. (source: https://github.com/git/git/blob/master/contrib/completion/git-completion.bash)
. ~/.bash/git-completion.bash

# Remove unused packages.
alias pacremove="pacman -Qtdq | sudo pacman -Rns -"

# List explicitly installed packages that are not dependencies.
paclist ()
{
    package_list_native=$(pacman -Qent)
    package_count_native=$(printf "$package_list_native\n" | wc -l)

    package_list_aur=$(pacman -Qm)
    package_count_aur=$(printf "$package_list_aur\n" | wc -l)

    packages_count_all=$(expr $package_count_native + $package_count_aur)

    printf "NATIVE:\n%s\nTOTAL: %s\n\nAUR:\n%s\nTOTAL: %s\nTOTAL ALL:%s\n" "$package_list_native" "$package_count_native" "$package_list_aur" "$package_count_aur" "$packages_count_all"
}

