#!/bin/bash

get_installed_version(){
	strings $MATTERMOST_DIR/resources/app.asar  | grep '"version": ' | head -1 | tr -d '",' | awk '{print $NF}'
}

get_latest_version(){
	curl -s -L $MATTERMOST_LINUX_URL | sed -n '/x64.tar.gz/ s/.*href="\([^"]*\).*/\1/p' | awk -F'/' '{print $(NF-1)}'
}

latest_version_is_installed(){
	local local_version=$(get_installed_version)
	local latest_version=$(get_latest_version)
	if [ "$local_version" == "$latest_version" ]; then
		return 0
	else
		return 1
	fi
}

mattermost_is_installed(){
	if [ -d $MATTERMOST_DIR ] && [ -x $MATTERMOST_DIR/mattermost-desktop ]; then
		return 0
	else
		return 1
	fi
}

install_latest_version(){
	MATTERMOST_TGZ_URL="$(curl -s -L $MATTERMOST_LINUX_URL | sed -n '/x64.tar.gz/ s/.*href="\([^"]*\).*/\1/p')"
	MATTERMOST_PKG_NAME=$(basename $MATTERMOST_TGZ_URL)

	if [ ! -d $MATTERMOST_DIR ]; then
		sudo mkdir -p $MATTERMOST_DIR
	fi


	wget -P /tmp/ $MATTERMOST_TGZ_URL

	sudo tar --strip=1 -C $MATTERMOST_DIR -xzf /tmp/$MATTERMOST_PKG_NAME

	sudo find $MATTERMOST_DIR -type d -exec chmod 0755 {} \;
	sudo find $MATTERMOST_DIR -type f -exec chmod 0644 {} \;
	sudo chmod +x $MATTERMOST_DIR/{*.so,*.bin,*.sh,mattermost-desktop}

	cd $MATTERMOST_DIR
	sudo ./create_desktop_file.sh
	sudo mv Mattermost.desktop /usr/local/share/applications/
}

MATTERMOST_DIR=/opt/mattermost-desktop
MATTERMOST_LINUX_URL="https://docs.mattermost.com/install/desktop.html#linux"

if mattermost_is_installed; then
	if ! latest_version_is_installed; then
		install_latest_version
	fi
else
	install_latest_version
fi

