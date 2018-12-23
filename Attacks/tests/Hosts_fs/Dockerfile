FROM ubuntu:latest
MAINTAINER Fani Dimou <fani.dimou92@gmail.com>

#Create userA with password A
#RUN useradd -m userA && echo "userA:A" | chpasswd

COPY for_container.sh /
#USER userA
ENTRYPOINT /bin/bash
