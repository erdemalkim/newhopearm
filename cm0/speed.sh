#!/bin/sh
DEVICE=/dev/ttyUSB0

stty -F $DEVICE raw icanon eof \^d 9600
st-flash write speed.bin 0x8000000
cat < $DEVICE
