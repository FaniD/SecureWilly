#!/bin/bash

echo "Insert the number of serial device that is open"
read d 
sudo stty 9600 < /dev/ttyS$d 	#set baud rate to default
echo "My message should print out to the other terminal window..."
echo "hello world" >/dev/ttyS$d
