FROM ubuntu:latest
MAINTAINER Fani Dimou <fani.dimou92@gmail.com>

RUN apt-get update && apt-get install docker.io -y && apt-get install -y curl socat

RUN useradd userA && echo "userA:A" | chpasswd
RUN useradd userB && echo "userB:B" | chpasswd

COPY add_user_to_docker_group.sh /

RUN mkdir Attack
RUN chown userA:userA /Attack
RUN chmod 744 /Attack

COPY attack1.sh /Attack
COPY attack2.sh /Attack

WORKDIR /

USER userA

ENTRYPOINT /bin/bash
