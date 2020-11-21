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

enable_sudo(){
	if sudo grep -q "^Defaults targetpw" /etc/sudoers; then
		sudo sed -i "s/^Defaults targetpw.*/# Defaults targetpw/g" /etc/sudoers
	fi

	if sudo grep -q "^ALL   ALL=(ALL) ALL" /etc/sudoers; then
		sudo sed -i "s/^ALL   ALL=(ALL) ALL.*/# ALL   ALL=(ALL) ALL/g" /etc/sudoers
	fi

	if sudo grep -q "^# %wheel ALL=(ALL) ALL" /etc/sudoers; then
		sudo sed -i "s/^# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/g" /etc/sudoers
	fi
	
	if [ ! -s /usr/share/polkit-1/actions/org.opensuse.pkexec.yast2.policy ]; then
		sudo bash -c "cat >/usr/share/polkit-1/actions/org.opensuse.pkexec.yast2.policy" <<-EOF
		<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE policyconfig PUBLIC "-//freedesktop//DTD PolicyKit Policy Configuration 1.0//EN" "http://www.freedesktop.org/software/polkit/policyconfig-1.dtd">
		<policyconfig>

		  <action id="org.opensuse.pkexec.yast2">
		    <message>Authentication is required to run YaST2</message>
		    <icon_name>yast2</icon_name>
		    <defaults>
		      <allow_any>auth_self</allow_any>
		      <allow_inactive>auth_self</allow_inactive>
		      <allow_active>auth_self</allow_active>
		    </defaults>
		    <annotate key="org.freedesktop.policykit.exec.path">/usr/sbin/yast2</annotate>
		    <annotate key="org.freedesktop.policykit.exec.allow_gui">true</annotate>
		  </action>

		</policyconfig>
		EOF
	fi

	if [ ! -s /etc/polkit-default-privs.local.bkup ]; then
		sudo mv /etc/polkit-default-privs.local /etc/polkit-default-privs.local.bkup
		sudo cp /etc/polkit-default-privs.standard /etc/polkit-default-privs.local
		sudo sed -i 's/auth_admin/auth_self/g' /etc/polkit-default-privs.local
	fi

	if [ ! -x /usr/local/sbin/yast2_polkit ]; then
		sudo bash -c "cat >/usr/local/sbin/yast2_polkit" <<-EOF
		#!/bin/bash
		
		if [ $(which pkexec) ]; then
		        pkexec --disable-internal-agent "/usr/sbin/yast2" "$@"
		else
		        /usr/sbin/yast2 "$@"
		fi
		EOF
		sudo chmod +x /usr/local/sbin/yast2_polkit
	fi

	if [ ! -s /usr/share/applications/YaST2.desktop ]; then
		sudo bash -c "cat >/usr/share/applications/YaST2.desktop" <<-EOF
		[Desktop Entry]
		X-SuSE-translate=true
		Type=Application
		Categories=Settings;System;X-SuSE-Core-System;X-SuSE-ControlCenter-System;X-GNOME-SystemSettings;
		Name=YaST2
		Icon=yast
		GenericName=Administrator Settings
		Exec=/usr/local/sbin/yast2_polkit
		Encoding=UTF-8
		Comment=Manage system-wide settings
		Comment[DE]=Systemweite administrative Einstellungen
		NoDisplay=false
		EOF
	fi

	if ! sudo test -s /etc/polkit-1/rules.d/10-sudo.rules; then
		sudo bash -c "cat >/etc/polkit-1/rules.d/10-sudo.rules" <<-EOF
		polkit.addAdminRule(function(action, subject) {
	        return ["unix-group:wheel"];
		});
		
		EOF
	fi
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

enable_sudo
path_cert_path_c6

scripts/bin/install-telegram.sh
scripts/bin/install-mattermost.sh

stow -vvv -t ~/ i3-gnome scripts term-setup

gnome-settings-tweaks.sh

# Disable wayland in gdm if enabled
if ! wayland_in_gdm; then
	disable_wayland_in_gdm
fi

