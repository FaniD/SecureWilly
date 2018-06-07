#!/bin/sh

#sudo /sbin/ldconfig -v
#useradd -m userd #Useradd is not permitted
echo "greetings" > hello
echo "ls -l to see /hello permissions"
ls -l ./ | grep hello
echo "Chown for userA and file /hello"
chown userA:userA ./hello #I used root and not userA because useradd was not permitted
echo "Now ls -l to see if it worked"
ls -l ./ | grep hello
