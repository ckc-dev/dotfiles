#
# ~/.bashrc
#

# If not running interactively, don't do anything.
[[ $- != *i* ]] && return

# Initialize external scripts path.
SCRIPTS_PATH=~/.config/.bash

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

# Load git prompt script. (source: https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh)
. $SCRIPTS_PATH/git-prompt.sh
export GIT_PS1_SHOWDIRTYSTATE=1

# Prompt.
PS1="[\u@${COLOR_BOLD}\h${COLOR_BOLD_RESET} ${COLOR4}\W${COLOR_RESET}] ${COLOR5}$(__git_ps1 "(%s)")${COLOR_RESET}$ "

# Fix some issues with GPG2.
export GPG_TTY=$(tty)

# Automatically cd into directories.
shopt -s autocd

# Automatically fix minor misspellings in directory names.
shopt -s cdspell
shopt -s direxpand
shopt -s dirspell

# Avoid duplicate entries in history.
export HISTCONTROL=ignoredups

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
alias va="source venv/bin/activate"
alias ve="python -m venv ./venv"

# Load git completion script. (source: https://github.com/git/git/blob/master/contrib/completion/git-completion.bash)
. $SCRIPTS_PATH/git-completion.bash

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
