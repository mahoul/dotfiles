#!/bin/bash

get_required_packages(){
	cat <<-EOF
	NetworkManager-applet 
	ca-certificates-cacert
	colordiff
	dmenu
	dpkg
	feh
	gnome-flashback
	gnome-font-viewer
	gucharmap
	htop
	lsb-release
	mc
	mozilla-nss-tools
	neofetch
	net-tools-deprecated
	pasystray
	rofi
	tmux
	tmux-powerline
	xdm-xsession
	xev
	EOF
}

missing_pkgs(){
	for pkg in $(get_required_packages); do
		rpm -q $pkg &>/dev/null || return 1
	done
	return 0
}

wayland_in_gdm(){
	grep -q "^WaylandEnable=false" /etc/gdm/custom.conf
}

disable_wayland_in_gdm(){
	sed -i "s/^#WaylandEnable.*/WaylandEnable=false/g" /etc/gdm/custom.conf
	systemctl restart display-manager
}

enable_sudo(){
	if grep -q "^Defaults targetpw" /etc/sudoers; then
		sed -i "s/^Defaults targetpw.*/# Defaults targetpw/g" /etc/sudoers
	fi

	if grep -q "^ALL   ALL=(ALL) ALL" /etc/sudoers; then
		sed -i "s/^ALL   ALL=(ALL) ALL.*/# ALL   ALL=(ALL) ALL/g" /etc/sudoers
	fi

	if grep -q "^# %wheel ALL=(ALL) ALL" /etc/sudoers; then
		sed -i "s/^# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/g" /etc/sudoers
	fi
	
	if [ ! -s /usr/share/polkit-1/actions/org.opensuse.pkexec.yast2.policy ]; then
		cat <<-EOF > /usr/share/polkit-1/actions/org.opensuse.pkexec.yast2.policy
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
		mv /etc/polkit-default-privs.local /etc/polkit-default-privs.local.bkup
		cp /etc/polkit-default-privs.standard /etc/polkit-default-privs.local
		sed -i 's/auth_admin/auth_self/g' /etc/polkit-default-privs.local
	fi

	if [ ! -x /usr/local/sbin/yast2_polkit ]; then
		cat<<-EOF > /usr/local/sbin/yast2_polkit
		#!/bin/bash
		
		if [ $(which pkexec) ]; then
		        pkexec --disable-internal-agent "/usr/sbin/yast2" "$@"
		else
		        /usr/sbin/yast2 "$@"
		fi
		EOF
		chmod +x /usr/local/sbin/yast2_polkit
	fi

	if [ ! -s /usr/share/applications/YaST2.desktop ]; then
		cat<<-EOF > /usr/share/applications/YaST2.desktop
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

	if [ ! -s /etc/polkit-1/rules.d/10-sudo.rules ]; then
		cat<<-EOF > /etc/polkit-1/rules.d/10-sudo.rules
		polkit.addAdminRule(function(action, subject) {
	        return ["unix-group:wheel"];
		});
		
		EOF
	fi
}

# Check if all required packages are installed and 
# launch installation if any of them is missing.
#
if ! missing_pkgs; then
	get_required_packages | sudo xargs zypper in -y
fi

# Disable wayland in gdm if enabled
if ! wayland_in_gdm; then
	disable_wayland_in_gdm
fi

# Link gnome-flashback to gdm pam file
if [ ! -h /etc/pam.d/gnome-flashback ]; then
	cd /etc/pam.d
	ln -s gdm gnome-flashback
	cd -
fi

enable_sudo

