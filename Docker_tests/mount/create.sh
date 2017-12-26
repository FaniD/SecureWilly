#!/bin/sh
echo "ls mount_here (it should be empty)"
ls ./mount_here
echo "Creating a new file in /mount_here"
echo "greetings" > /mount_here/hello
echo "Now check volume data to see if file hello exists"
