#!/bin/bash
 
docker run -t --name server --net search_network -p 8983:8983 --security-opt "apparmor=cloudsuiteweb-searchserver_profile" cloudsuite/web-search:server 12g 1
docker run -it --name client --net search_network --security-opt "apparmor=cloudsuiteweb-searchclient_profile" cloudsuite/web-search:client server_address 50 90 60 60

docker stop server
