FROM ubuntu:latest
MAINTAINER Fani Dimou <fani.dimou92@gmail.com>

RUN mkdir hello
RUN chmod 777 hello
RUN chown root:users hello
WORKDIR hello
COPY ./ hello
ENTRYPOINT pwd
