#!/bin/sh

#Run on host
#python3 -m http.server --bind localhost

#Run on host to test is server is listening
#curl localhost:8000

#Run the container to see if host we can reach host through the container
docker build -t net_test .
#Without profile everything works fine
#docker run -it --rm --net=host net_test

#Profile time:
#docker run -it --rm --net=host --security-opt "apparmor=net_profile" net_test

#Let's see what happens if we give net_admin capability:
docker run -it --rm --net=host --security-opt "apparmor=client_profile" net_test
