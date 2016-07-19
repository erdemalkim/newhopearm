#!/usr/bin/env python3
import serial
import sys,time
import config

dev = serial.Serial("/dev/ttyUSB0", 921600,timeout = None)
def guard():
    x = int.from_bytes(dev.read(1),'big')
    while x != 10:
        x = int.from_bytes(dev.read(1),'big')
        print(x)

b = []  

print("\nTesting New Hope client, please run the test_client.sh script.", file=sys.stderr)

send = [x for x in config.send_a]
print("> Waiting for signal..", file=sys.stderr)

guard();
print("> Connected!\n> Transmitting...", file=sys.stderr)

dev.write(send)
print("> Send!", file=sys.stderr)

guard();
print("> Reading...", file=sys.stderr)

for i in range(0,2048):
    x = dev.read()
    b.append(x)
b = [int.from_bytes(x,'big') for x in b]

if config.send_b == b:
    print("> Received correct byte array!", file=sys.stderr)
else:
    print("> Transmission error occured!", file=sys.stderr)
    for i in range(0,len(b)):
        print(str(b[i])+',',end="")


guard();
while not dev.inWaiting():
    pass
b = []
for i in range(0,5):
    x = dev.read()
    b.append(x)

b = [chr(int.from_bytes(x,'big')) for x in b]
print('> '+''.join(b) , file=sys.stderr)


