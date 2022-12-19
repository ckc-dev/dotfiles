# NOTE: THIS SCRIPT IS MEANT FOR FRESH TERMUX INSTALLS.
# This script might modify packages and override files.
# Make sure this is what you want to do.

set -e

# Create temporary directory.
mkdir -p $HOME/.tmp/
TEMP_DIR=$HOME/.tmp/

# Set up storage.
termux-setup-storage

# Uninstall unused packages, update current ones, and install useful ones.
pkg uninstall nano -y
pkg upgrade -y
pkg install openssh gnupg vim python ranger wget -y
pkg clean

# Download and set font.
FONT_DESTINATION=$HOME/.termux/font.ttf
FONT_SOURCE_LOCATION=variable_ttf/FiraCode-VF.ttf
GITHUB_API_FONT_REPO_LATEST_RELEASE_URL=https://api.github.com/repos/tonsky/FiraCode/releases/latest
DOWNLOAD_URL=$(curl $GITHUB_API_FONT_REPO_LATEST_RELEASE_URL\
	| grep "browser_download_url.*.zip"\
	| cut -d : -f 2,3\
	| tr -d \"
)

wget -O $TEMP_DIR/font.zip $DOWNLOAD_URL
unzip $TEMP_DIR/font.zip -d $TEMP_DIR/font/
cp $TEMP_DIR/font/$FONT_SOURCE_LOCATION $FONT_DESTINATION


# Set up dotfiles.
bash setup_dotfiles.sh

# Generate configuration files.
python $HOME/.dotfiles-pyconfig/pyconfig.py termux-colors

# Set up GPG and SSH keys.
bash setup_gpg_ssh_keys.sh

# Delete temporary directory.
rm -rf $TEMP_DIR
