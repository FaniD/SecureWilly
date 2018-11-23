#!/bin/sh
docker build -t net_test .
docker run -it --rm --net=host net_test
