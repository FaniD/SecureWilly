FROM ubuntu:latest
MAINTAINER Fani Dimou <fani.dimou92@gmail.com>

RUN apt-get update && apt-get install docker.io -y

RUN useradd userA && echo "userA:A" | chpasswd
RUN useradd userB && echo "userB:B" | chpasswd

COPY add_user_to_docker_group.sh /

RUN mkdir Attack
RUN chown userA:userA /Attack
RUN chmod 744 /Attack

COPY 4_attack.sh /Attack

WORKDIR /

USER userA

ENTRYPOINT /bin/bash
