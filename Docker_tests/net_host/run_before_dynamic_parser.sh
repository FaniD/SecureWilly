#!/bin/sh

#Run on host
python3 -m http.server --bind localhost

#Run on host to test if server is listening
#curl localhost:8000

#Run the container to see if we can reach host through the container
#docker run -it --rm --net=host buildpack-deps:curl curl localhost:8000
