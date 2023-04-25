#!/bin/bash

# Quick script to disable an internal webcam if an external one is attached, or
# enable the internal one if the external one's not attached.

# by Shimon Rura, 25 Jan 2018. In the public domain.

# To use, run `lsusb` and identify the lines for your internal and external camera devices.
# For example, mine are:
# internal:
# Bus 001 Device 004: ID 04f2:b52c Chicony Electronics Co., Ltd 
# external:
# Bus 001 Device 017: ID 1908:2310 GEMBIRD 

# Then edit these lines to reference the IDs above.
HOME_DIR="/sys/bus/usb/devices"
# INT_CAMERA_IDS="0bda:568c"
INT_CAMERA_IDS="13d3:5406"
EXT_CAMERA_IDS="046d:0892"
### Don't edit below this line. ###############################################

INT_CAMERA_PORT=`(for i in $HOME_DIR/*; do echo $i=\`cat $i/idVendor 2>/dev/null\`:\`cat $i/idProduct 2>/dev/null\`; done)|grep $INT_CAMERA_IDS|awk -F= '{print $1}'`
EXT_CAMERA_PORT=`(for i in $HOME_DIR/*; do echo $i=\`cat $i/idVendor 2>/dev/null\`:\`cat $i/idProduct 2>/dev/null\`; done)|grep $EXT_CAMERA_IDS|awk -F= '{print $1}'`

echo Internal camera port: $INT_CAMERA_PORT
echo External camera port: $EXT_CAMERA_PORT

if [ -n "$EXT_CAMERA_PORT" ]; then
    echo External camera is attached. Turning off internal camera.
    echo "0" | sudo tee $INT_CAMERA_PORT/bConfigurationValue

elif [ -n "$INT_CAMERA_PORT" ]; then
    echo Only internal camera is attached. Turning on.
    echo "1" | sudo tee $INT_CAMERA_PORT/bConfigurationValue

else
    echo No cameras detected. No action.
fi
