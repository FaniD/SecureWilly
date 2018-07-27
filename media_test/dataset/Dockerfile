FROM ubuntu:14.04
MAINTAINER Alexandros Daglis <alexandros.daglis@epfl.ch>

RUN apt-get update -y && apt-get install -y --no-install-recommends \
      build-essential \
    && rm -rf /var/lib/apt/lists/*

COPY files /root/

RUN mkdir /videos
RUN cd /root/filegen && make && ./generate_video_files_and_logs.sh /videos

VOLUME ["/videos"]
