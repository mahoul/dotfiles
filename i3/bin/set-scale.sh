#!/bin/bash

SF=$(gsettings get org.gnome.desktop.interface text-scaling-factor)

if [ "$SF" != "1.25" ]; then
	gsettings set org.gnome.desktop.interface text-scaling-factor 1.25
	if pidof polybar &>/dev/null; echo $?; then
		sed -i 's/dpi =.*/dpi = 125/g' ~/.config/polybar/config
		i3-msg restart
	fi
else
	gsettings set org.gnome.desktop.interface text-scaling-factor 1.00
	if pidof polybar &>/dev/null; echo $?; then
		sed -i 's/dpi =.*/dpi = 100/g' ~/.config/polybar/config
		i3-msg restart
	fi
fi



