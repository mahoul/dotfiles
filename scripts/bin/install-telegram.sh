#!/bin/bash

telegram_is_installed(){
	if [ -d $TELEGRAM_DIR ] && [ -x $TELEGRAM_BIN ]; then
		return 0
	else
		return 1
	fi
}

TELEGRAM_DIR=/opt/Telegram
TELEGRAM_BIN=$TELEGRAM_DIR/Telegram

if ! telegram_is_installed; then

	curl -L --output /tmp/telegram.tar.xz https://telegram.org/dl/desktop/linux
	sudo tar -C /opt -xJvf /tmp/telegram.tar.xz
	sudo rm -f /tmp/telegram.tar.xz	

	$TELEGRAM_BIN

#	[ ! -d /usr/local/share/applications ] && sudo mkdir -p /usr/local/share/applications
#	if [ ! -s /usr/local/share/applications/Telegram_Desktop.desktop ]; then
#		sudo bash -c "cat >/usr/local/share/applications/Telegram_Desktop.desktop" <<-EOF
#		[Desktop Entry]
#		Version=1.0
#		Name=Telegram Desktop
#		Comment=Official desktop version of Telegram messaging app
#		TryExec=/opt/Telegram/Telegram
#		Exec=/opt/Telegram/Telegram -- %u
#		Icon=telegram
#		Terminal=false
#		StartupWMClass=TelegramDesktop
#		Type=Application
#		Categories=Chat;Network;InstantMessaging;Qt;
#		MimeType=x-scheme-handler/tg;
#		Keywords=tg;chat;im;messaging;messenger;sms;tdesktop;
#		X-GNOME-UsesNotifications=true
#		EOF
#	fi

fi


