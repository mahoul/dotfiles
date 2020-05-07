#!/bin/sh
xrandr --output DVI-D-0 --off --output HDMI-0 --off --output DP-0 --primary --mode 1920x1080 --pos 0x0 --rotate left --output DP-1 --off
sleep 5s
gnome-extensions disable gTile@vibou
gnome-extensions enable gTile@vibou
