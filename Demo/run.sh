#!/bin/sh
#And now run the container
docker build . -t demo
docker run -p 8887:8887 --pid="host" demo
