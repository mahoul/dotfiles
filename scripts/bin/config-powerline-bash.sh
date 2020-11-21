#!/bin/bash

is_deb_ubuntu(){
	which lsb_release &>/dev/null
}

is_debian(){
	lsb_release -s --id | grep -q Debian
}

is_ubuntu(){
	lsb_release -s --id | grep -q Ubuntu
}

is_opensuse(){
	grep -q '^NAME.*openSUSE' /etc/os-release
}

is_fedora(){
	grep -q '^NAME.*Fedora' /etc/os-release
}

guess_distro(){
	if is_deb_ubuntu; then
		if is_ubuntu; then
			echo ubuntu
		elif is_debian; then
			echo debian
		fi
	else
		if is_fedora; then
			echo fedora
		elif is_opensuse; then
			echo opensuse
		fi
	fi
}

case "$(guess_distro)" in
	ubuntu|debian)
		POWERLINE_PATH=/usr/share/powerline/bindings/bash/powerline.sh
		;;
	*)
		POWERLINE_PATH=/usr/share/powerline/bash/powerline.sh
		;;
esac

if ! grep -q '`which powerline-daemon`' ~/.bashrc; then
	TAB="$(printf '\t')"
	cat <<-EOF >> ~/.bashrc
	
	if [ "\$TERM" != "linux" ]; then
	${TAB}if [ -f \`which powerline-daemon\` ]; then
	${TAB}${TAB}powerline-daemon -q
	${TAB}${TAB}POWERLINE_BASH_CONTINUATION=1
	${TAB}${TAB}POWERLINE_BASH_SELECT=1
	${TAB}${TAB}. $POWERLINE_PATH
	${TAB}fi
	fi

	EOF
fi

