FROM ubuntu:latest
MAINTAINER Fani Dimou <fani.dimou92@gmail.com>

#Install vim
RUN apt-get -y update && apt-get install -y vim
COPY dev.sh .
CMD ["./dev.sh"]


