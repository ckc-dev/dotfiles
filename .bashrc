#
# ~/.bashrc
#

# Initialize external scripts path.
SCRIPTS_PATH=~/.config/.bash

# Initialize color variables.
color_reset="\[\033[0m\]"
color_bold="\[\033[1m\]"
color_bold_reset="\[\033[21m\]"
color_italic="\[\033[3m\]"
color_italic_reset="\[\033[23m\]"
color_underline="\[\033[4m\]"
color_underline_reset="\[\033[24m\]"
color_reverse="\[\033[7m\]"
color_reverse_reset="\[\033[27m\]"
color0="$(echo -e "\033[30m")"
color1="$(echo -e "\033[31m")"
color2="$(echo -e "\033[32m")"
color3="$(echo -e "\033[33m")"
color4="$(echo -e "\033[34m")"
color5="$(echo -e "\033[35m")"
color6="$(echo -e "\033[36m")"
color7="$(echo -e "\033[37m")"

# If not running interactively, don't do anything.
[[ $- != *i* ]] && return

# Load git prompt script. (source: https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh)
. $SCRIPTS_PATH/git-prompt.sh
export GIT_PS1_SHOWDIRTYSTATE=1

# Prompt.
PS1="[\u@${color_bold}\h${color_bold_reset} ${color4}\W${color_reset}] ${color5}$(__git_ps1 "(%s)")${color_reset}$ "

# Fix some issues with GPG2.
export GPG_TTY=$(tty)

# Automatically cd into directories.
shopt -s autocd

# Automatically fix minor misspellings in directory names.
shopt -s cdspell
shopt -s dirspell
shopt -s direxpand

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
alias ve="python -m venv ./venv"
alias va="source venv/bin/activate"

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
