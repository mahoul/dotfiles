#!/bin/bash

if su -c 'grep -q "^Defaults targetpw" /etc/sudoers'; then
	su -c 'sed -i "s/^Defaults targetpw.*/# Defaults targetpw/g" /etc/sudoers'
fi

if su -c 'grep -q "^ALL   ALL=(ALL) ALL" /etc/sudoers'; then
	su -c '"s/^ALL   ALL=(ALL) ALL.*/# ALL   ALL=(ALL) ALL/g" /etc/sudoers'
fi

if su -c 'grep -q "^# %wheel ALL=(ALL) ALL" /etc/sudoers'; then
	su -c 'sed -i "s/^# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/g" /etc/sudoers'
fi

if [ ! -s /usr/share/polkit-1/actions/org.opensuse.pkexec.yast2.policy ]; then
	cat >/tmp/org.opensuse.pkexec.yast2.policy <<-EOF
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
	su -c 'mv /tmp/org.opensuse.pkexec.yast2.policy /usr/share/polkit-1/actions/'
fi

if [ ! -s /etc/polkit-default-privs.local.bkup ]; then
	su -c 'mv /etc/polkit-default-privs.local /etc/polkit-default-privs.local.bkup'
	su -c 'cp /etc/polkit-default-privs.standard /etc/polkit-default-privs.local'
	su -c 'sed -i "s/auth_admin/auth_self/g" /etc/polkit-default-privs.local'
fi

if [ ! -x /usr/local/sbin/yast2_polkit ]; then
	cat >/tmp/yast2_polkit <<-EOF
	#!/bin/bash
	
	if [ $(which pkexec) ]; then
	        pkexec --disable-internal-agent "/usr/sbin/yast2" "$@"
	else
	        /usr/sbin/yast2 "$@"
	fi
	EOF
	su -c 'mv /tmp/yast2_polkit /usr/local/sbin/'
	su -c 'chmod +x /usr/local/sbin/yast2_polkit'
fi

if [ ! -s /usr/share/applications/YaST2.desktop ]; then
	cat >/tmp/YaST2.desktop <<-EOF
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
	su -c 'mv /tmp/YaST2.desktop /usr/share/applications/'
fi

if ! su -c 'test -s /etc/polkit-1/rules.d/10-sudo.rules'; then
	cat >/tmp/10-sudo.rules <<-EOF
	polkit.addAdminRule(function(action, subject) {
        return ["unix-group:wheel"];
	});
	
	EOF
	su -c 'mv /tmp/10-sudo.rules /etc/polkit-1/rules.d/'
fi

su -c 'usermod -a -G wheel $USER'

