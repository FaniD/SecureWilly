#!/bin/bash
 
#docker network create streaming_network
docker create --name streaming_dataset cloudsuite/media-streaming:dataset
docker run -d --name streaming_server --volumes-from streaming_dataset --net streaming_network --security-opt "apparmor=cloudsuitemedia-streamingserver_profile" cloudsuite/media-streaming:server
docker run -t --name streaming_client -v /output:/output --volumes-from streaming_dataset --net streaming_network --security-opt "apparmor=cloudsuitemedia-streamingclient_profile" cloudsuite/media-streaming:client streaming_server

docker stop streaming_server
