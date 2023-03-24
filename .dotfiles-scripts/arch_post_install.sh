# NOTE: THIS SCRIPT IS MEANT FOR FRESH ARCH LINUX INSTALLS.
# This script might modify packages and override files.
# Make sure this is what you want to do.

set -e

printf "Step 1: Enabling multilib repositories on pacman..."
if grep -q "\[multilib\]" /etc/pacman.conf; then
  echo "\nMultilib repositories are already enabled.\n"
else
  sudo bash -c "printf '\n\n[multilib]\nInclude = /etc/pacman.d/mirrorlist\n' >> /etc/pacman.conf"
fi

printf "\nStep 2: Installing packages...\n"
sudo pacman -Syu\
  acpilight\
  base-devel\
  darktable\
  firefox\
  gcc\
  gimp\
  i3-gaps\
  i3status\
  nomacs\
  noto-fonts\
  noto-fonts-cjk\
  noto-fonts-emoji\
  ntfs-3g\
  openssh\
  pavucontrol\
  pulseaudio\
  python\
  python-pip\
  rofi\
  rxvt-unicode\
  steam\
  vlc\
  xorg-server\
  xorg-xinit\
  xorg-xsetroot\
  hdparm\
  pcmanfm-gtk3\
  flameshot\
  android-file-transfer\
  playerctl\
  qbittorrent\
  dotnet-runtime\
  dotnet-sdk\
  udisks\
  udiskie

printf "\nStep 3: Setting up dotfiles...\n"
bash setup_dotfiles.sh

printf "\nStep 4: Generating configuration files...\n"
python $HOME/.dotfiles-pyconfig/pyconfig.py -x termux-colors

printf "\nStep 5: Installing AUR helper...\n"
mkdir /tmp/aur/
git clone https://aur.archlinux.org/paru.git /tmp/aur/
cd /tmp/aur/
makepkg -si
cd -
rm -rf /tmp/aur/

printf "\nStep 6: Installing AUR packages...\n"
paru\
  visual-studio-code-bin\
  rider

printf "\nAll done!\n"
