#!/bin/sh

useradd -m userA && echo "userA:A" | chpasswd
echo "greetings" > hello
echo "ls -l to see /hello permissions"
ls -l / | grep hello
echo "Chown for UserA and file /hello"
chown userA:userA ./hello
echo "Now ls -l to see if it worked"
ls -l / | grep hello
