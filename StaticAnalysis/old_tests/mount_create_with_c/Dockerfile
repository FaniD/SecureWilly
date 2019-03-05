FROM ubuntu:latest
MAINTAINER Fani Dimou <fani.dimou92@gmail.com>

#Install vim
RUN apt-get -y update && apt-get install -y vim

##Create file hello, create directory Heys 
RUN mkdir /mount_here

COPY create /
CMD ["./create"]
