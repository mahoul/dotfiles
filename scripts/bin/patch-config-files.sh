#!/bin/bash

CURRENT_USER=$(whoami)

FILES_TO_PATCH="$HOME/.Xresources-regolith \
$HOME/.config/regolith/styles/root \
$HOME/.config/regolith/styles/lascaille/root"

for file in $FILES_TO_PATCH; do
	sed -i -e "s#/home/[a-z]*[A-Z]*[0-9]*/#/home/$CURRENT_USER/#g" .Xresources-regolith
done

