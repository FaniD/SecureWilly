#!/bin/bash
 
docker create --name streaming_dataset --security-opt "apparmor=cloudsuitemedia-streamingdataset_profile" cloudsuite/media-streaming:dataset
docker run -d --name streaming_server --volumes-from streaming_dataset --net streaming_network --security-opt "apparmor=cloudsuitemedia-streamingserver_profile" cloudsuite/media-streaming:server
docker run -t --name streaming_client1 -v /output:/output --volumes-from streaming_dataset --net streaming_network --security-opt "apparmor=cloudsuitemedia-streamingclient1_profile" cloudsuite/media-streaming:client streaming_server

docker run -t --name streaming_client2 -v /output:/output --volumes-from streaming_dataset --net streaming_network --security-opt apparmor=cloudsuitemedia-streamingclient2_profile cloudsuite/media-streaming:client streaming_server
docker run -t --name streaming_client3 -v /output:/output --volumes-from streaming_dataset --net streaming_network --security-opt apparmor=cloudsuitemedia-streamingclient3_profile cloudsuite/media-streaming:client streaming_server
docker run -t --name streaming_client4 -v /output:/output --volumes-from streaming_dataset --net streaming_network --security-opt apparmor=cloudsuitemedia-streamingclient4_profile cloudsuite/media-streaming:client streaming_server
docker run -t --name streaming_client5 -v /output:/output --volumes-from streaming_dataset --net streaming_network --security-opt apparmor=cloudsuitemedia-streamingclient5_profile cloudsuite/media-streaming:client streaming_server
docker run -t --name streaming_client6 -v /output:/output --volumes-from streaming_dataset --net streaming_network --security-opt apparmor=cloudsuitemedia-streamingclient6_profile cloudsuite/media-streaming:client streaming_server
docker run -t --name streaming_client7 -v /output:/output --volumes-from streaming_dataset --net streaming_network --security-opt apparmor=cloudsuitemedia-streamingclient7_profile cloudsuite/media-streaming:client streaming_server
docker run -t --name streaming_client8 -v /output:/output --volumes-from streaming_dataset --net streaming_network --security-opt apparmor=cloudsuitemedia-streamingclient8_profile cloudsuite/media-streaming:client streaming_server
docker run -t --name streaming_client9 -v /output:/output --volumes-from streaming_dataset --net streaming_network --security-opt apparmor=cloudsuitemedia-streamingclient9_profile cloudsuite/media-streaming:client streaming_server
docker run -t --name streaming_client10 -v /output:/output --volumes-from streaming_dataset --net streaming_network --security-opt apparmor=cloudsuitemedia-streamingclient10_profile cloudsuite/media-streaming:client streaming_server
docker run -t --name streaming_client11 -v /output:/output --volumes-from streaming_dataset --net streaming_network --security-opt apparmor=cloudsuitemedia-streamingclient11_profile cloudsuite/media-streaming:client streaming_server
docker run -t --name streaming_client12 -v /output:/output --volumes-from streaming_dataset --net streaming_network --security-opt apparmor=cloudsuitemedia-streamingclient12_profile cloudsuite/media-streaming:client streaming_server
docker run -t --name streaming_client13 -v /output:/output --volumes-from streaming_dataset --net streaming_network --security-opt apparmor=cloudsuitemedia-streamingclient13_profile cloudsuite/media-streaming:client streaming_server
docker run -t --name streaming_client14 -v /output:/output --volumes-from streaming_dataset --net streaming_network --security-opt apparmor=cloudsuitemedia-streamingclient14_profile cloudsuite/media-streaming:client streaming_server
docker run -t --name streaming_client15 -v /output:/output --volumes-from streaming_dataset --net streaming_network --security-opt apparmor=cloudsuitemedia-streamingclient15_profile cloudsuite/media-streaming:client streaming_server
docker run -t --name streaming_client16 -v /output:/output --volumes-from streaming_dataset --net streaming_network --security-opt apparmor=cloudsuitemedia-streamingclient16_profile cloudsuite/media-streaming:client streaming_server
docker run -t --name streaming_client17 -v /output:/output --volumes-from streaming_dataset --net streaming_network --security-opt apparmor=cloudsuitemedia-streamingclient17_profile cloudsuite/media-streaming:client streaming_server
docker run -t --name streaming_client18 -v /output:/output --volumes-from streaming_dataset --net streaming_network --security-opt apparmor=cloudsuitemedia-streamingclient18_profile cloudsuite/media-streaming:client streaming_server
docker run -t --name streaming_client19 -v /output:/output --volumes-from streaming_dataset --net streaming_network --security-opt apparmor=cloudsuitemedia-streamingclient19_profile cloudsuite/media-streaming:client streaming_server
docker run -t --name streaming_client20 -v /output:/output --volumes-from streaming_dataset --net streaming_network --security-opt apparmor=cloudsuitemedia-streamingclient20_profile cloudsuite/media-streaming:client streaming_server
docker run -t --name streaming_client21 -v /output:/output --volumes-from streaming_dataset --net streaming_network --security-opt apparmor=cloudsuitemedia-streamingclient21_profile cloudsuite/media-streaming:client streaming_server
docker run -t --name streaming_client22 -v /output:/output --volumes-from streaming_dataset --net streaming_network --security-opt apparmor=cloudsuitemedia-streamingclient22_profile cloudsuite/media-streaming:client streaming_server
docker run -t --name streaming_client23 -v /output:/output --volumes-from streaming_dataset --net streaming_network --security-opt apparmor=cloudsuitemedia-streamingclient23_profile cloudsuite/media-streaming:client streaming_server
docker run -t --name streaming_client24 -v /output:/output --volumes-from streaming_dataset --net streaming_network --security-opt apparmor=cloudsuitemedia-streamingclient24_profile cloudsuite/media-streaming:client streaming_server
docker run -t --name streaming_client25 -v /output:/output --volumes-from streaming_dataset --net streaming_network --security-opt apparmor=cloudsuitemedia-streamingclient25_profile cloudsuite/media-streaming:client streaming_server
docker run -t --name streaming_client26 -v /output:/output --volumes-from streaming_dataset --net streaming_network --security-opt apparmor=cloudsuitemedia-streamingclient26_profile cloudsuite/media-streaming:client streaming_server
docker run -t --name streaming_client27 -v /output:/output --volumes-from streaming_dataset --net streaming_network --security-opt apparmor=cloudsuitemedia-streamingclient27_profile cloudsuite/media-streaming:client streaming_server
docker run -t --name streaming_client28 -v /output:/output --volumes-from streaming_dataset --net streaming_network --security-opt apparmor=cloudsuitemedia-streamingclient28_profile cloudsuite/media-streaming:client streaming_server
docker run -t --name streaming_client29 -v /output:/output --volumes-from streaming_dataset --net streaming_network --security-opt apparmor=cloudsuitemedia-streamingclient29_profile cloudsuite/media-streaming:client streaming_server
docker run -t --name streaming_client30 -v /output:/output --volumes-from streaming_dataset --net streaming_network --security-opt apparmor=cloudsuitemedia-streamingclient30_profile cloudsuite/media-streaming:client streaming_server
docker run -t --name streaming_client31 -v /output:/output --volumes-from streaming_dataset --net streaming_network --security-opt apparmor=cloudsuitemedia-streamingclient31_profile cloudsuite/media-streaming:client streaming_server
docker run -t --name streaming_client32 -v /output:/output --volumes-from streaming_dataset --net streaming_network --security-opt apparmor=cloudsuitemedia-streamingclient32_profile cloudsuite/media-streaming:client streaming_server
docker stop streaming_server










































































































































































