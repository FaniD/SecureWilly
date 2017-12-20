FROM ubuntu:latest
MAINTAINER Fani Dimou <fani.dimou92@gmail.com>

#Install vim
RUN apt-get -y update && apt-get install -y vim

#Create file hello, create directory Heys 
RUN echo "greetings" > hello
RUN mkdir "Heys"
RUN echo "abc" > test #by default r to everybody, w only to root

RUN mkdir /test_proc


COPY ./test /test_proc/.
WORKDIR /test_proc
#CMD ["./test"]
ENTRYPOINT /bin/bash

