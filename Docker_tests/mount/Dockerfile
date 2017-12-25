FROM ubuntu:latest
MAINTAINER Fani Dimou <fani.dimou92@gmail.com>

#Install vim
RUN apt-get -y update && apt-get install -y vim

##Create file hello, create directory Heys 
RUN echo "greetings" > hello

##Create userA with password A
RUN useradd -m userA && echo "userA:A" | chpasswd

ENTRYPOINT /bin/bash
