FROM ubuntu:latest
MAINTAINER Fani Dimou <fani.dimou92@gmail.com>

#Install Docker
RUN apt-get update && apt-get install docker.io -y
#Copy the script attack inside the container
COPY spc.sh /
ENTRYPOINT /bin/bash
