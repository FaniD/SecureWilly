FROM ubuntu:latest
MAINTAINER Fani Dimou <fani.dimou92@gmail.com>

#Install vim
RUN apt-get -y update && apt-get install -y vim

#Exposing port 80 tcp
EXPOSE 80/tcp

#Create file greetings, create directory HelloB
RUN echo "Hello A" > greetings
RUN mkdir "HelloB"
RUN echo "Hello everybody" > hello #by default r to everybody, w only to root

#Create 2 users, userA with password A, userB with password B
RUN useradd userA && echo "userA:A" | chpasswd
RUN useradd userB && echo "userB:B" | chpasswd

#Test 1
#greetings: userA owner and permissions rwx only userA
#everybody else only r permission
#test who can edit the file -> Only userA
RUN chown userA:userA /greetings
RUN chmod 744 /greetings

#Test 2
#HelloB: userB owner and only userB rwx permissions in dir
#everybody else only r permission
RUN chown userB:userB /HelloB/
RUN chmod 744 /HelloB

USER userA

ENTRYPOINT /bin/bash
