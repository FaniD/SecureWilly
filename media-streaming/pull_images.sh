#!/bin/sh
docker pull cloudsuite/media-streaming:dataset
docker network create streaming_network
docker pull cloudsuite/media-streaming:server
docker pull cloudsuite/media-streaming:client
