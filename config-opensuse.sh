#!/bin/bash

get_required_packages(){
	cat <<-EOF
	MozillaThunderbird
	NetworkManager-applet 
	ca-certificates-cacert
	colordiff
	dmenu
	dpkg
	dunst
	feh
	fontawesome-fonts
	gnome-flashback
	gnome-font-viewer
	gucharmap
	htop
	i3
	libnotify-tools
	lsb-release
	mc
	mozilla-nss-tools
	nemo
	neofetch
	net-tools-deprecated
	parcellite
	pasystray
	pavucontrol
	rofi
	stow
	tmux
	tmux-powerline
	xdm-xsession
	xev
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

path_cert_path_c6(){

	if [ ! -d /etc/pki/tls/certs ]; then
		sudo mkdir -p /etc/pki/tls/certs
	fi

	if [ ! -h /etc/pki/tls/certs/ca-bundle.crt ]; then
		sudo ln -s /etc/ssl/ca-bundle.pem /etc/pki/tls/certs/ca-bundle.crt
	fi
}

[ -d $HOME/bin ] && export PATH=$HOME/bin:$PATH

sudo zypper -n addrepo https://download.opensuse.org/repositories/home:sonaj96/openSUSE_Tumbleweed/home:sonaj96.repo
sudo zypper --gpg-auto-import-keys -n refresh 

# Check if all required packages are installed and 
# launch installation if any of them is missing.
#
if ! missing_pkgs; then
	get_required_packages | xargs sudo zypper in -y
fi

# Link gnome-flashback to gdm pam file
if [ ! -h /etc/pam.d/gnome-flashback ]; then
	cd /etc/pam.d
	sudo ln -s gdm gnome-flashback
	cd -
fi

path_cert_path_c6

scripts/bin/install-telegram.sh
scripts/bin/install-mattermost.sh

stow -vvv -t ~/ i3-gnome scripts term-setup

gnome-settings-tweaks.sh

# Disable wayland in gdm if enabled
if ! wayland_in_gdm; then
	disable_wayland_in_gdm
fi

