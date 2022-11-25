#!/bin/bash

SF=$(gsettings get org.gnome.desktop.interface text-scaling-factor)

if [ "$SF" != "1.25" ]; then
	gsettings set org.gnome.desktop.interface text-scaling-factor 1.25
else
	gsettings set org.gnome.desktop.interface text-scaling-factor 1.00
fi


