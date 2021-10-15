# If not running interactively, don't do anything.
[[ $- != *i* ]] && return

# Initialize external scripts path.
SCRIPTS_PATH=$HOME/.config/bash

# Initialize color variables.
COLOR_BOLD="$(echo -e "\[\033[1m\]")"
COLOR_BOLD_RESET="$(echo -e "\[\033[21m\]")"
COLOR_ITALIC="$(echo -e "\[\033[3m\]")"
COLOR_ITALIC_RESET="$(echo -e "\[\033[23m\]")"
COLOR_RESET="$(echo -e "\[\033[0m\]")"
COLOR_REVERSE="$(echo -e "\[\033[7m\]")"
COLOR_REVERSE_RESET="$(echo -e "\[\033[27m\]")"
COLOR_UNDERLINE="$(echo -e "\[\033[4m\]")"
COLOR_UNDERLINE_RESET="$(echo -e "\[\033[24m\]")"
COLOR0="$(echo -e "\[\033[30m\]")"
COLOR1="$(echo -e "\[\033[31m\]")"
COLOR2="$(echo -e "\[\033[32m\]")"
COLOR3="$(echo -e "\[\033[33m\]")"
COLOR4="$(echo -e "\[\033[34m\]")"
COLOR5="$(echo -e "\[\033[35m\]")"
COLOR6="$(echo -e "\[\033[36m\]")"
COLOR7="$(echo -e "\[\033[37m\]")"

# Load Git prompt script. (https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh)
. $SCRIPTS_PATH/git-prompt.sh

# Load Git completion script. (source: https://github.com/git/git/blob/master/contrib/completion/git-completion.bash)
. $SCRIPTS_PATH/git-completion.bash

# Show unstaged (*) and staged (+) changes next to branch names in Git repositories. 
export GIT_PS1_SHOWDIRTYSTATE=1

# Fix some issues with GPG2.
export GPG_TTY=$(tty)

# Prompt.
PS1="[\u@${COLOR_BOLD}\h${COLOR_BOLD_RESET} ${COLOR4}\W${COLOR_RESET}] ${COLOR5}"'$(__git_ps1 "(%s)")'"${COLOR_RESET}$ "

# Automatically cd into directories.
shopt -s autocd

# Automatically fix minor misspellings in directory names.
shopt -s cdspell
shopt -s direxpand
shopt -s dirspell

# Avoid duplicate entries in history.
export HISTCONTROL=ignoredups

# Control .dotfiles Git repository.
alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"

# Display colors with "ls" command.
alias ls="ls --color=auto"

# Better file listing.
alias ll="ls -plash"

# Better file copyping.
alias cp="cp -vir"

# Better file moving.
alias mv="mv -vi"

# Better file removal.
alias rm="rm -Irv"

# Better directory creation.
alias mkdir="mkdir -pv"

# Create and load a Python virtual environment.
alias ve="python -m venv .venv"
alias va="source .venv/bin/activate"

# Remove unused packages.
alias pacremove="pacman -Qtdq | sudo pacman -Rns -"

# List explicitly installed packages that are not dependencies.
paclist ()
{
    PACKAGE_LIST_NATIVE=$(pacman -Qent)
    PACKAGE_COUNT_NATIVE=$(printf "$PACKAGE_LIST_NATIVE\n" | wc -l)

    PACKAGE_LIST_AUR=$(pacman -Qm)
    PACKAGE_COUNT_AUR=$(printf "$PACKAGE_LIST_AUR\n" | wc -l)

    PACKAGE_COUNT_TOTAL=$(expr $PACKAGE_COUNT_NATIVE + $PACKAGE_COUNT_AUR)

    printf "NATIVE: %s\n%s\n\nAUR: %s\n%s\n\nTOTAL: %s\n" "$PACKAGE_COUNT_NATIVE" "$PACKAGE_LIST_NATIVE" "$PACKAGE_COUNT_AUR" "$PACKAGE_LIST_AUR" "$PACKAGE_COUNT_TOTAL"
}

# Reboot directly to Windows. (https://unix.stackexchange.com/a/112284)
reboot_to_windows ()
{
    WINDOWS_TITLE=$(sudo grep -i windows /boot/grub/grub.cfg | cut -d "'" -f 2)
    sudo grub-reboot "$WINDOWS_TITLE" && sudo reboot
}
