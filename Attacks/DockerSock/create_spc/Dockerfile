FROM ubuntu:latest
MAINTAINER Fani Dimou <fani.dimou92@gmail.com>

RUN apt-get update && apt-get install docker.io -y
COPY spc.sh /
ENTRYPOINT /bin/bash
