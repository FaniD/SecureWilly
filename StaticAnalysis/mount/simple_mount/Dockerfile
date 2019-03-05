FROM ubuntu:latest
MAINTAINER Fani Dimou <fani.dimou92@gmail.com>

#Create a volume to do the bind
RUN mkdir /mount_here
RUN useradd -m userA && echo "userA:A" | chpasswd

#Run a script that creates a file into the binded volume, which should be seen to the host if bind is successful
#COPY create.sh /
USER userA
ENTRYPOINT /bin/bash
#CMD ["./create.sh"]
