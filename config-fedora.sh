#!/bin/bash

get_required_packages(){
	cat <<-EOF
	alacritty
	arandr
	bat
	btop
	colordiff
	dmenu
	exa
	feh
	fontawesome-fonts
	git
	google-noto-sans-mono-fonts
	guake
	htop
	i3-gaps
	jetbrains-mono-fonts
	kde-wallpapers
	krb5-workstation
	mc
	mozilla-fira-sans-fonts
	net-tools
	nmap
	nss-tools
	powerline
	powerline-fonts
	virt-viewer
	stow
	tmux
	tmux-powerline
	tmux-powerline
	vim
	vim-airline
	vim-powerline
	virt-viewer
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
	org.telegram.desktop \
	com.spotify.Client \
	org.remmina.Remmina \
	us.zoom.Zoom \
	org.flameshot.Flameshot \
	com.visualstudio.code \
	org.videolan.VLC
	

# Link gnome-flashback to gdm pam file
#if [ ! -h /etc/pam.d/gnome-flashback ]; then
#	cd /etc/pam.d
#	sudo ln -s gdm gnome-flashback
#	cd -
#fi

stow -vvv --adopt -t ~/ term-setup i3

#gnome-settings-tweaks.sh