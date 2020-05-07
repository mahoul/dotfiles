#!/bin/bash

POWERLINE_PKGS="powerline"

FONTS_PKGS="fonts-firacode \
fonts-font-awesome \
fonts-jetbrains-mono \
fonts-powerline"

REST_OF_PKGS="adcli \
arandr \
arc-theme \
chromium-browser \
colordiff \
curl \
dconf-editor \
evolution \
git \
gnome-backgrounds \
gnome-flashback \
gnome-tweaks \
guake \
krb5-user \
libcanberra-gtk-module \
libenchant1c2a \
libnss-sss \
libpam-sss \
mc \
nemo \
parcellite \
pavucontrol \
plymouth-theme-ubuntu-logo \
realmd \
remmina-plugin-rdp \
rofi \
rxvt-unicode-256color \
samba-common-bin \
ssh \
sssd \
sssd-tools \
telegram-desktop \
tmux \
ubuntu-artwork \
vim \
virt-viewer"

# Install Powerline packages
sudo apt install -y $POWERLINE_PKGS

# Install Font packages
sudo apt install -y $FONTS_PKGS

# Install rest of packages
sudo apt install -y $REST_OF_PKGS

# Install spotify-client
curl -sS https://download.spotify.com/debian/pubkey.gpg | sudo apt-key add -
echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt-get update
sudo apt-get install -y spotify-client

# Install Mattermost desktop
MATTERMOST_LINUX_URL="https://docs.mattermost.com/install/desktop.html#linux"
MATTERMOST_DEB_URL="$(curl -s -L $MATTERMOST_LINUX_URL | sed -n '/amd64.deb/ s/.*href="\([^"]*\).*/\1/p')"
MATTERMOST_PKG_NAME=$(basename $MATTERMOST_DEB_URL)
wget -P /tmp/ $MATTERMOST_DEB_URL
sudo dpkg -i /tmp/$MATTERMOST_PKG_NAME

# Install Brave Browser
sudo apt install -y apt-transport-https curl
curl -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc | sudo apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add -
echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update
sudo apt install -y brave-browser

# Install stow and stage all changes
sudo apt install -y stow
stow *

# Enable night light 
gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true

