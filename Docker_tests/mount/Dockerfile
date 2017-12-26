FROM ubuntu:latest
MAINTAINER Fani Dimou <fani.dimou92@gmail.com>

#Install vim
RUN apt-get -y update && apt-get install -y vim

#Create a volume to do the bind
RUN mkdir /mount_here

#Run a script that creates a file into the binded volume, which should be seen to the host if bind is successful
COPY create.sh /
CMD ["./create.sh"]
