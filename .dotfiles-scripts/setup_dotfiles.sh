REPOSITORY_HTTPS="https://github.com/ckc-dev/dotfiles.git"
REPOSITORY_SSH="git@github.com:ckc-dev/dotfiles.git"

printf "Creating '.gitgnore'...\n"
printf ".dotfiles" >> $HOME/.gitignore

printf "Cloning repository...\n"
git clone --bare $REPOSITORY_HTTPS $HOME/.dotfiles

printf "Changing repository HTTPS URI to SSH...\n"
git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME remote set-url origin $REPOSITORY_SSH

printf "Configuring repository...\n"
git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME checkout --force
git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME config --local status.showUntrackedFiles no

printf "Deleting '.gitignore'...\n"
rm $HOME/.gitignore
