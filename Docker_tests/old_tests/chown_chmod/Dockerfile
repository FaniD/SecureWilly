FROM ubuntu:latest
MAINTAINER Fani Dimou <fani.dimou92@gmail.com>

#RUN mkdir ./hello
RUN echo "greetings" > hello
RUN apt-get -y update && apt-get install -y vim 
#ENV SGN FD
#RUN chmod 777 letsee
RUN mkdir "src" && chmod -R 777 "src"
RUN chown -R root.users /src
COPY ./ src
RUN chmod 744 "./hello"
#RUN chown user "./hello"
#RUN mkdir -p "$SGN/src" "$SGN/bin" && chmod -R 777 "$SGN"
#WORKDIR src
ENTRYPOINT /bin/bash
