FROM ubuntu:latest
MAINTAINER Fani Dimou <fani.dimou92@gmail.com>

#Install vim
RUN apt-get -y update && apt-get install -y vim

#Create file hello, create directory Heys 
RUN echo "greetings" > hello
RUN mkdir "Heys"

#Create 2 users, userA with password A, userB with password B
RUN useradd -m userA && echo "userA:A" | chpasswd
RUN useradd -m userB && echo "userB:B" | chpasswd

#Test 1
#chown hello -> userA owner and permissions rwx only userA, everybody else only r permission
#test who can edit the file -> Only userA
RUN chown userA:userA /hello
RUN chmod 744 /hello

#Test 2, userB owns Heys and only userB has rwx permissions there
RUN chown userB:userB /Heys/
RUN chmod 744 /Heys

#USER userB
#USER userA

ENTRYPOINT /bin/bash
