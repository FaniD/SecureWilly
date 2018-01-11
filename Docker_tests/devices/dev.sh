#!/bin/bash

d=0 
while true
do
	sudo setserial /dev/ttyS$d -v autoconfig &> answer #check serial device to see if busy
	if grep -q 'busy' answer
	then
		echo "tty$d is busy, try another device"
		((d++)) #increment counter to check next device
	else
		sudo stty 9600 < /dev/ttyS$d 	#this one is not busy, set baud rate to default
		echo "tty$d is ready to use"
		rm answer
		break
	fi
done

echo "I'm listening..."
#anything sent up the cable should print out to the terminal window
cat -v </dev/ttyS$d

