#!/bin/bash

get_required_packages(){
	cat <<-EOF
	colordiff
	dmenu
	dpkg
	dunst
	feh
	fontawesome-fonts
	gnome-calculator
	gnome-flashback
	gnome-font-viewer
	gnome-session-xsession
	gnome-tweaks
	google-noto-sans-mono-fonts
	gucharmap
	guake
	htop
	i3
	mc
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
	rofi
	stow
	thunderbird
	tmux
	tmux-powerline
	xorg-x11-utils
	xorg-x11-xinit-session
	EOF
}

missing_pkgs(){
	for pkg in $(get_required_packages); do
		sudo rpm -q $pkg &>/dev/null || return 1
	done
	return 0
}

wayland_in_gdm(){
	sudo grep -q "^WaylandEnable=false" /etc/gdm/custom.conf
}

disable_wayland_in_gdm(){
	sudo sed -i "s/^#WaylandEnable.*/WaylandEnable=false/g" /etc/gdm/custom.conf
	sudo systemctl restart display-manager
}

[ -d $HOME/bin ] && export PATH=$HOME/bin:$PATH

if [ ! -s /etc/fedora-release ]; then

	# Enable required repos
	sudo yum install -y epel-release

	sudo dnf install -y https://pkgs.dyn.su/el8/base/x86_64/raven-release-1.0-2.el8.noarch.rpm

	cd /etc/yum.repos.d/

	sudo sed -i -e 's/^enabled.*/enabled=1/g' CentOS-Stream-PowerTools.repo
	sudo wget https://copr.fedorainfracloud.org/coprs/yselkowitz/gnome-flashback/repo/epel-8/yselkowitz-gnome-flashback-epel-8.repo

	cd -
fi

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

#scripts/bin/install-telegram.sh
#scripts/bin/install-mattermost.sh

stow -vvv -t ~/ i3-gnome scripts term-setup

gnome-settings-tweaks.sh

# Disable wayland in gdm if enabled
if ! wayland_in_gdm; then
	disable_wayland_in_gdm
fi

