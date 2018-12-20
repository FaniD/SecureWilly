FROM ubuntu:latest
MAINTAINER Fani Dimou <fani.dimou92@gmail.com>

RUN apt-get update && apt-get install docker.io -y

COPY 2_inspect_container.sh /

WORKDIR /
#RUN useradd userA && echo "userA:A" | chpasswd
#USER userA
ENTRYPOINT /bin/bash
