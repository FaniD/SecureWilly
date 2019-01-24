FROM ubuntu:latest
MAINTAINER Fani Dimou <fani.dimou92@gmail.com>

#Install Docker
RUN apt-get update && apt-get install docker.io -y

#Add two new users and fix passwords
RUN useradd userA && echo "userA:A" | chpasswd

#Create a directory belonging to userA
#fix the permissions and copy the attack script in there
RUN mkdir Attack
RUN chown userA:userA /Attack
RUN chmod 744 /Attack
COPY 4_attack.sh /Attack

#Copy the script which the outside attacker will use
COPY add_user_to_docker_group.sh /

WORKDIR /
USER userA
ENTRYPOINT /bin/bash
