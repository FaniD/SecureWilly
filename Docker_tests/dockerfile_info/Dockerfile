FROM ubuntu:latest
MAINTAINER Fani Dimou <fani.dimou92@gmail.com>

#Install vim
RUN apt-get -y update && apt-get install -y vim

#Exposing port 80 tcp
EXPOSE 80/tcp

#Create file hello, create directory Heys 
RUN echo "Hello A" > greetings
RUN mkdir "Hello_B"
RUN echo "Hello everybody" > test #by default r to everybody, w only to root

#Create 2 users, userA with password A, userB with password B
RUN useradd userA && echo "userA:A" | chpasswd
RUN useradd userB && echo "userB:B" | chpasswd

#Test 1
#greetings: userA owner and permissions rwx only userA
#everybody else only r permission
#test who can edit the file -> Only userA
RUN chown userA:userA /hello
RUN chmod 744 /hello

#Test 2
#Hello_B: userB owner and only userB rwx permissions in dir
#everybody else only r permission
RUN chown userB:userB /Heys/
RUN chmod 744 /Heys

USER userA

ENTRYPOINT /bin/bash
