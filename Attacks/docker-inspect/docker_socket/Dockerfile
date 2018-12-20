FROM ubuntu:latest
MAINTAINER Fani Dimou <fani.dimou92@gmail.com>

RUN apt-get update && apt-get install docker.io -y

RUN useradd userA && echo "userA:A" | chpasswd
RUN useradd userB && echo "userB:B" | chpasswd

COPY 2_inspect_container.sh /
COPY add_user_to_docker_group.sh /

WORKDIR /
USER userA
ENTRYPOINT /bin/bash
