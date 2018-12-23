#!/bin/sh

docker build -t dind .
docker run --privileged -t -i dind

