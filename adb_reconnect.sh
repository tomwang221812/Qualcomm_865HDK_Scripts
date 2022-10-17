#!/bin/bash

set -x

export USB_SERIAL='333e1468'
export REMOTE_SERIAL='10.136.8.136:5555'

lsusb
echo "(**) USB serial ${USB_SERIAL}"
echo "(**) Remote serial ${REMOTE_SERIAL}"
sleep 1

echo "(**) Rebooting remote device ${REMOTE_SERIAL} from host"
adb -s $REMOTE_SERIAL reboot
echo "(**) Disconnect adb from remote device ${REMOTE_SERIAL}"
adb disconnect $REMOTE_SERIAL
echo "(**) Kill adb server..."
adb kill-server
echo "(**) Start adb server..."
adb start-server
echo "(!!) Connect device usb in 5 sec"
sleep 5
echo "(**) Waiting device to connect..."
adb -s $USB_SERIAL wait-for-device tcpip 5555
sleep 1
adb connect $REMOTE_SERIAL
echo "(**) Waiting device to connect and give root permission"
adb -s $REMOTE_SERIAL wait-for-device root
