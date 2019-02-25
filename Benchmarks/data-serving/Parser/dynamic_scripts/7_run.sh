#!/bin/bash
 
docker run -d --name cassandra-server --net serving_network --security-opt "apparmor=cloudsuitedata-servingserver_profile" cloudsuite/data-serving:server cassandra
docker run --name cassandra-client --net serving_network --security-opt "apparmor=cloudsuitedata-servingclient_profile" cloudsuite/data-serving:client "cassandra-server"

docker stop cassandra-server
