#!/bin/bash
 
docker network create streaming_network
docker create --name cloudsuite/media-streaming:dataset cloudsuite/media-streaming:dataset
docker run -d --name cloudsuite/media-streaming:server --security-opt apparmor=cloudsuitemedia-streaming:server_profile --volumes-from streaming_dataset --net streaming_network cloudsuite/media-streaming:server
docker run -t --name cloudsuite/media-streaming:client --security-opt apparmor=cloudsuitemedia-streaming:client_profile -v /output:/output --volumes-from streaming_dataset --net streaming_network cloudsuite/media-streaming:client streaming_server

docker stop cloudsuite/media-streaming:server
