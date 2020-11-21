#!/bin/bash

gsettings set org.gnome.gnome-flashback desktop false
gsettings set org.gnome.gnome-flashback notifications false
gsettings set org.gnome.gnome-flashback root-background false
gsettings set org.gnome.gnome-flashback status-notifier-watcher false

gsettings set org.gnome.Terminal.Legacy.Settings headerbar false
gsettings set org.gnome.Terminal.Legacy.Settings default-show-menubar false
gsettings set org.gnome.Terminal.Legacy.Settings menu-accelerator-enabled false
gsettings set org.gnome.Terminal.Legacy.Settings theme-variant 'dark'

gsettings set org.gnome.desktop.interface gtk-theme 'Gruvbox-Material-Dark'
gsettings set org.gnome.desktop.interface icon-theme 'Gruvbox-Material-Dark'
gsettings set org.gnome.desktop.interface document-font-name 'Fira Code Medium 11'
gsettings set org.gnome.desktop.interface font-name 'Fira Sans Medium 11'
gsettings set org.gnome.desktop.interface monospace-font-name 'Fira Code Medium 10'

gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true

