#!/bin/bash

SF=$(gsettings get org.gnome.desktop.interface text-scaling-factor)

if [ "$SF" != "1.25" ]; then
	gsettings set org.gnome.desktop.interface text-scaling-factor 1.25
else
	gsettings set org.gnome.desktop.interface text-scaling-factor 1.00
fi

if pidof polybar &>/dev/null; echo $?; then
	POLY_SF=$(grep dpi ~/.config/polybar/config | awk '{ print $3 }')
	if [ "$POLY_SF" != 125 ]; then
		sed -i 's/dpi =.*/dpi = 125/g' ~/.config/polybar/config
	else
                sed -i 's/dpi =.*/dpi = 100/g' ~/.config/polybar/config
	fi
	i3-msg restart
fi


