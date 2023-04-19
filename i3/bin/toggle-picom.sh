#!/bin/bash

picom_is_running(){
	if [ -s $PICOM_PID_FILE ]; then
		PICOM_PID=$(cat $PICOM_PID_FILE)
		if [ -d /proc/$PICOM_PID ]; then
			return 0
		else
			rm -f $PICOM_PID_FILE
			return 1
		fi
	else
		return 1
	fi
	
}


PICOM_PID_FILE="/tmp/picom_${USER}.pid"

if picom_is_running; then
	kill -9 $(cat $PICOM_PID_FILE)
	rm -f $PICOM_PID_FILE
else
	picom --write-pid-path $PICOM_PID_FILE &
fi

