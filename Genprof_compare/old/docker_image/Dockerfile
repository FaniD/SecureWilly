FROM ubuntu:latest
MAINTAINER Fani Dimou <fani.dimou92@gmail.com>

#Install vim
RUN apt-get -y update && apt-get install -y vim

#Create userA with password A
RUN useradd -m userA && echo "userA:A" | chpasswd

#Create file hello, create directory Heys 
#RUN echo "greetings" > hello
COPY chown_it.sh /
#RUN chown userA:userA /hello

#USER userA
WORKDIR /
CMD ["./chown_it.sh"]
