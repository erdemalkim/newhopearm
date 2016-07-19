#!/usr/bin/env python3
import serial
import sys,time
import config

dev = serial.Serial("/dev/ttyUSB0", 921600)

def guard():
    while int.from_bytes(dev.read(1),'big')!= 10:
        pass

a = []  

print("\nTesting New Hope server, please run the test_server.sh script.", file=sys.stderr)

print("> Waiting for signal..", file=sys.stderr)

guard();
print("> Connected!\n> Reading...", file=sys.stderr)

for i in range(0,2048):
    x = dev.read()
    a.append(x)


a = [int.from_bytes(x,'big') for x in a]
a = a[:1824]

if config.send_a == a:
    print("> Received correct byte array!", file=sys.stderr)
else:
    print("> Transmission error occured!", file=sys.stderr)
    for i in range(0,len(a)):
        #if not (a[i] == config.send_a[i]):
        print(a[i],end=",")
    print()


print("> Transmitting...", file=sys.stderr)

for i in range(0,8):
    guard();
    send = [x for x in config.send_b[256*i:256*(i+1)]]
    dev.write(send)
print("> Send!", file=sys.stderr)


guard();
b = []
for i in range(0,6):
    x = dev.read()
    b.append(x)

b = [chr(int.from_bytes(x,'big')) for x in b]
print("> "+''.join(b) , file=sys.stderr)


'''while dev.inWaiting():
  print(int.from_bytes(dev.read(1),'big'))  '''
