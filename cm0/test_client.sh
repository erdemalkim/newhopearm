#!/bin/sh
DEVICE=/dev/ttyUSB0

#stty -F $DEVICE raw icanon eof \^d 912600
st-flash write client.bin 0x8000000
#cat < $DEVICE
