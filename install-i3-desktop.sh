#!/bin/bash

POWERLINE_PKGS="powerline \
powerline-fonts \
tmux-powerline"

FONTS_PKGS="fira-code-fonts \
fontawesome-fonts \
jetbrains-mono-fonts \
mozilla-fira-*"

I3_PKGS="arc-theme \
colordiff \
conky \
chromium \
git \
gnome-flashback \
gnome-tweaks \
i3-gaps \
make \
mc \
nemo \
parcellite \
pavucontrol \
picom \
python3-i3ipc \
rofi \
rxvt-unicode \
vim"

# Install Powerline packages
sudo yum install -y $POWERLINE_PKGS

# Enable powerline on bash
#if ! grep -q powerline ~/.bashrc; then
#	cat <<-'EOF' >> ~/.bashrc
#	# User specific aliases and functions
#	if [ -f `which powerline-daemon` ]; then
#		powerline-daemon -q
#		POWERLINE_BASH_CONTINUATION=1
#		POWERLINE_BASH_SELECT=1
#		. /usr/share/powerline/bash/powerline.sh
#	fi
#	EOF
#fi

# Enable powerline on vim
#if ! grep -q powerline ~/.vimrc; then
#	cat <<-'EOF' >> ~/.vimrc
#	set laststatus=2 " Always display the statusline in all windows
#	set showtabline=2 " Always display the tabline, even if there is only one tab
#	set noshowmode " Hide the default mode text (e.g. -- INSERT -- below the statusline)
#
#	python3 from powerline.vim import setup as powerline_setup
#	python3 powerline_setup()
#	python3 del powerline_setup
#	EOF
#fi

# Install Font packages
sudo yum install -y $FONTS_PKGS

# Install i3-gaps
sudo dnf copr enable -y nforro/i3-gaps
sudo dnf copr disable -y odilhao/dzen2
sudo yum localinstall -y https://ftp.nluug.nl/os/Linux/distr/fedora/linux/releases/31/Everything/x86_64/os/Packages/d/dzen2-0.8.5-24.20100104svn.fc31.x86_64.rpm
sudo dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Install i3 packages
sudo yum install -y $I3_PKGS

# Install i3blocks
sudo dnf copr enable -y shengis/i3blocks
sudo dnf install -y i3blocks

# Install tmux tpm
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Install i3-gnome
git clone https://github.com/i3-gnome/i3-gnome.git /tmp/i3-gnome/
cd /tmp/i3-gnome
sudo make install

# Get dotfiles and rsync them to the home folder
#git clone https://github.com/mahoul/dotfiles.git /tmp/dotfiles
rsync -avP --exclude $0 --exclude .git --exclude README.md ./ ~/

# Disable desktop management for gnome-flashback and only enable 
# background drawing.
gsettings set org.gnome.gnome-flashback desktop false
gsettings set org.gnome.gnome-flashback root-background true

# Enable night light 
gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true

# Set Arc-Darker as default GTK Theme
gsettings set org.gnome.desktop.interface gtk-theme 'Arc-Darker'

# Set JetBrains Mono as default monospace font
gsettings set org.gnome.desktop.interface monospace-font-name 'JetBrains Mono Medium 11'

# Restore gnome-terminal profiles
dconf load /org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/ < ~/.config/gnome-terminal-profiles/gnome-terminal.default.profile
dconf load /org/gnome/terminal/legacy/profiles:/:d481bf68-8d93-4ff6-8101-f0ab26181db9/ < ~/.config/gnome-terminal-profiles/gnome-terminal.gruvbox.profile
dconf load /org/gnome/terminal/legacy/profiles:/:51a0063f-2172-45c8-825f-7da4c5c4445d/ < ~/.config/gnome-terminal-profiles/gnome-terminal.gruvbox-dark.profile

# Restart gdm
#sudo systemctl restart gdm

