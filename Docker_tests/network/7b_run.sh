#!/bin/sh

#Run on host
#python3 -m http.server --bind localhost

#Run on host to test is server is listening
#curl localhost:8000

#Run the container to see if host we can reach host through the container
docker build -t net_test .
docker run -it --rm --net=host net_test #buildpack-deps:curl
#curl localhost:8000
#--security-opt "apparmor=net_profile"
