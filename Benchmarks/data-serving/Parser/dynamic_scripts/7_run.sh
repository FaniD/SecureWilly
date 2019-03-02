#!/bin/bash
 
docker run -d --name cassandra-server-seed --net serving_network --security-opt "apparmor=cloudsuitedata-servingserver_profile" cloudsuite/data-serving:server cassandra
docker run -d --name cassandra-server1 --net serving_network -e CASSANDRA_SEEDS=cassandra-server-seed --security-opt "apparmor=cloudsuitedata-servingserver_profile" cloudsuite/data-serving:server
docker run --name cassandra-client --net serving_network --security-opt "apparmor=cloudsuitedata-servingclient_profile" cloudsuite/data-serving:client "cassandra-server-seed,cassandra-server1"

docker stop cassandra-server-seed
docker stop cassandra-server1
