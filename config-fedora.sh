#!/bin/bash

get_required_packages(){
	cat <<-EOF
	alacritty
	bat
	btop
	colordiff
	dmenu
	exa
	feh
	fontawesome-fonts
	google-noto-sans-mono-fonts
	guake
	htop
	i3-gaps
	jetbrains-mono-fonts
	mc
	mozilla-fira-sans-fonts
	net-tools
	nss-tools
	papirus-icon-theme
	powerline
	powerline-fonts
	stow
	tmux
	tmux-powerline
	tmux-powerline
	vim
	vim-airline
	vim-powerline
	xdotool
	xprop
	EOF
}

missing_pkgs(){
	for pkg in $(get_required_packages); do
		sudo rpm -q $pkg &>/dev/null || return 1
	done
	return 0
}

[ -d $HOME/bin ] && export PATH=$HOME/bin:$PATH

# Check if all required packages are installed and 
# launch installation if any of them is missing.
#
if ! missing_pkgs; then
	get_required_packages | xargs sudo yum install -y
fi

# Enable flatpaks and install them
#
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install -y \
	com.brave.Browser \
	com.hamrick.VueScan \
	io.github.mimbrero.WhatsAppDesktop \
	org.filezillaproject.Filezilla \
	org.telegram.desktop

# Link gnome-flashback to gdm pam file
#if [ ! -h /etc/pam.d/gnome-flashback ]; then
#	cd /etc/pam.d
#	sudo ln -s gdm gnome-flashback
#	cd -
#fi

#stow -vvv --adopt -t ~/ term-setup i3

#gnome-settings-tweaks.sh


