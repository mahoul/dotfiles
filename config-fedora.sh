#!/bin/bash

get_required_packages(){
	cat <<-EOF
	bat
	btop
	colordiff
	dmenu
	dunst
	exa
	feh
	fontawesome-fonts
	gnome-calculator
	gnome-extensions-app
	gnome-flashback
	gnome-font-viewer
	gnome-session-xsession
	gnome-tweaks
	google-noto-sans-mono-fonts
	guake
	gucharmap
	htop
	i3-gaps
	jetbrains-mono-fonts
	mc
	mozilla-fira-sans-fonts
	nemo
	neofetch
	net-tools
	network-manager-applet
	nss-tools
	parcellite
	pasystray
	pavucontrol
	picom
	polybar
	powerline
	powerline-fonts
	rofi
	stow
	thunderbird
	tmux
	tmux-powerline
	tmux-powerline
	vim
	vim-airline
	vim-powerline
	xorg-x11-xinit-session
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

# Link gnome-flashback to gdm pam file
#if [ ! -h /etc/pam.d/gnome-flashback ]; then
#	cd /etc/pam.d
#	sudo ln -s gdm gnome-flashback
#	cd -
#fi

#stow -vvv -t ~/ i3-gnome scripts term-setup

#gnome-settings-tweaks.sh


