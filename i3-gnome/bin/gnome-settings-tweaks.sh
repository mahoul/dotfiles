#!/bin/bash


# Disable desktop management for notificacions on gnome-flashback 
# and disable background drawing too.
gsettings set org.gnome.gnome-flashback desktop 		false
gsettings set org.gnome.gnome-flashback notifications 		false
gsettings set org.gnome.gnome-flashback root-background 	false
gsettings set org.gnome.gnome-flashback status-notifier-watcher false

# Restore gnome-terminal profiles
dconf load /org/gnome/terminal/legacy/profiles:/ < ~/.config/gnome-terminal-profiles

# Tune-up the gnome-terminal
# 
gsettings set org.gnome.Terminal.Legacy.Settings headerbar 			false
gsettings set org.gnome.Terminal.Legacy.Settings default-show-menubar 		false
gsettings set org.gnome.Terminal.Legacy.Settings menu-accelerator-enabled 	false

# Adjust window resize with secondary button
gsettings set org.gnome.desktop.wm.preferences resize-with-right-button 	true

# Adjust gnome-shell
gsettings set org.gnome.shell disabled-extensions	'[]'
gsettings set org.gnome.shell enabled-extensions        '['background-logo@fedorahosted.org', 'user-theme@gnome-shell-extensions.gcampax.github.com', 'dash-to-dock@micxgx.gmail.com']'

# Adjust the themes on Gnome
gsettings set org.gnome.desktop.interface gtk-theme 	 'Nordic-bluish-accent-v40'
gsettings set org.gnome.shell.extensions.user-theme name 'Nordic-bluish-accent-v40'
gsettings set org.gnome.desktop.interface icon-theme 	 'Papirus-Dark'

# Adjust the fonts
#
gsettings set org.gnome.desktop.interface document-font-name 	'Fira Sans Medium 11'
gsettings set org.gnome.desktop.interface font-name 		'Fira Sans Medium 11'
gsettings set org.gnome.desktop.interface monospace-font-name 	'JetBrains Mono Medium 11'

# Enable night light 
gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true


