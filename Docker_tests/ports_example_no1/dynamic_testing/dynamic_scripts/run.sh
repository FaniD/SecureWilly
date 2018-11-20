#!/bin/sh
#And now run the container
docker build . -t ports
docker -d run --ports "8887:8887" --name server ports

./curl_it.sh
