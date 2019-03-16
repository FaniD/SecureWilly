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
docker run -t --name streaming_client33 -v /output:/output --volumes-from streaming_dataset --net streaming_network --security-opt apparmor=cloudsuitemedia-streamingclient33_profile cloudsuite/media-streaming:client streaming_server
docker run -t --name streaming_client34 -v /output:/output --volumes-from streaming_dataset --net streaming_network --security-opt apparmor=cloudsuitemedia-streamingclient34_profile cloudsuite/media-streaming:client streaming_server
docker run -t --name streaming_client35 -v /output:/output --volumes-from streaming_dataset --net streaming_network --security-opt apparmor=cloudsuitemedia-streamingclient35_profile cloudsuite/media-streaming:client streaming_server
docker run -t --name streaming_client36 -v /output:/output --volumes-from streaming_dataset --net streaming_network --security-opt apparmor=cloudsuitemedia-streamingclient36_profile cloudsuite/media-streaming:client streaming_server
docker run -t --name streaming_client37 -v /output:/output --volumes-from streaming_dataset --net streaming_network --security-opt apparmor=cloudsuitemedia-streamingclient37_profile cloudsuite/media-streaming:client streaming_server
docker run -t --name streaming_client38 -v /output:/output --volumes-from streaming_dataset --net streaming_network --security-opt apparmor=cloudsuitemedia-streamingclient38_profile cloudsuite/media-streaming:client streaming_server
docker run -t --name streaming_client39 -v /output:/output --volumes-from streaming_dataset --net streaming_network --security-opt apparmor=cloudsuitemedia-streamingclient39_profile cloudsuite/media-streaming:client streaming_server
docker run -t --name streaming_client40 -v /output:/output --volumes-from streaming_dataset --net streaming_network --security-opt apparmor=cloudsuitemedia-streamingclient40_profile cloudsuite/media-streaming:client streaming_server
docker run -t --name streaming_client41 -v /output:/output --volumes-from streaming_dataset --net streaming_network --security-opt apparmor=cloudsuitemedia-streamingclient41_profile cloudsuite/media-streaming:client streaming_server
docker run -t --name streaming_client42 -v /output:/output --volumes-from streaming_dataset --net streaming_network --security-opt apparmor=cloudsuitemedia-streamingclient42_profile cloudsuite/media-streaming:client streaming_server
docker run -t --name streaming_client43 -v /output:/output --volumes-from streaming_dataset --net streaming_network --security-opt apparmor=cloudsuitemedia-streamingclient43_profile cloudsuite/media-streaming:client streaming_server
docker run -t --name streaming_client44 -v /output:/output --volumes-from streaming_dataset --net streaming_network --security-opt apparmor=cloudsuitemedia-streamingclient44_profile cloudsuite/media-streaming:client streaming_server
docker run -t --name streaming_client45 -v /output:/output --volumes-from streaming_dataset --net streaming_network --security-opt apparmor=cloudsuitemedia-streamingclient45_profile cloudsuite/media-streaming:client streaming_server
docker run -t --name streaming_client46 -v /output:/output --volumes-from streaming_dataset --net streaming_network --security-opt apparmor=cloudsuitemedia-streamingclient46_profile cloudsuite/media-streaming:client streaming_server
docker run -t --name streaming_client47 -v /output:/output --volumes-from streaming_dataset --net streaming_network --security-opt apparmor=cloudsuitemedia-streamingclient47_profile cloudsuite/media-streaming:client streaming_server
docker run -t --name streaming_client48 -v /output:/output --volumes-from streaming_dataset --net streaming_network --security-opt apparmor=cloudsuitemedia-streamingclient48_profile cloudsuite/media-streaming:client streaming_server
docker run -t --name streaming_client49 -v /output:/output --volumes-from streaming_dataset --net streaming_network --security-opt apparmor=cloudsuitemedia-streamingclient49_profile cloudsuite/media-streaming:client streaming_server
docker run -t --name streaming_client50 -v /output:/output --volumes-from streaming_dataset --net streaming_network --security-opt apparmor=cloudsuitemedia-streamingclient50_profile cloudsuite/media-streaming:client streaming_server
docker run -t --name streaming_client51 -v /output:/output --volumes-from streaming_dataset --net streaming_network --security-opt apparmor=cloudsuitemedia-streamingclient51_profile cloudsuite/media-streaming:client streaming_server
docker run -t --name streaming_client52 -v /output:/output --volumes-from streaming_dataset --net streaming_network --security-opt apparmor=cloudsuitemedia-streamingclient52_profile cloudsuite/media-streaming:client streaming_server
docker run -t --name streaming_client53 -v /output:/output --volumes-from streaming_dataset --net streaming_network --security-opt apparmor=cloudsuitemedia-streamingclient53_profile cloudsuite/media-streaming:client streaming_server
docker run -t --name streaming_client54 -v /output:/output --volumes-from streaming_dataset --net streaming_network --security-opt apparmor=cloudsuitemedia-streamingclient54_profile cloudsuite/media-streaming:client streaming_server
docker run -t --name streaming_client55 -v /output:/output --volumes-from streaming_dataset --net streaming_network --security-opt apparmor=cloudsuitemedia-streamingclient55_profile cloudsuite/media-streaming:client streaming_server
docker run -t --name streaming_client56 -v /output:/output --volumes-from streaming_dataset --net streaming_network --security-opt apparmor=cloudsuitemedia-streamingclient56_profile cloudsuite/media-streaming:client streaming_server
docker run -t --name streaming_client57 -v /output:/output --volumes-from streaming_dataset --net streaming_network --security-opt apparmor=cloudsuitemedia-streamingclient57_profile cloudsuite/media-streaming:client streaming_server
docker run -t --name streaming_client58 -v /output:/output --volumes-from streaming_dataset --net streaming_network --security-opt apparmor=cloudsuitemedia-streamingclient58_profile cloudsuite/media-streaming:client streaming_server
docker run -t --name streaming_client59 -v /output:/output --volumes-from streaming_dataset --net streaming_network --security-opt apparmor=cloudsuitemedia-streamingclient59_profile cloudsuite/media-streaming:client streaming_server
docker run -t --name streaming_client60 -v /output:/output --volumes-from streaming_dataset --net streaming_network --security-opt apparmor=cloudsuitemedia-streamingclient60_profile cloudsuite/media-streaming:client streaming_server
docker run -t --name streaming_client61 -v /output:/output --volumes-from streaming_dataset --net streaming_network --security-opt apparmor=cloudsuitemedia-streamingclient61_profile cloudsuite/media-streaming:client streaming_server
docker run -t --name streaming_client62 -v /output:/output --volumes-from streaming_dataset --net streaming_network --security-opt apparmor=cloudsuitemedia-streamingclient62_profile cloudsuite/media-streaming:client streaming_server
docker run -t --name streaming_client63 -v /output:/output --volumes-from streaming_dataset --net streaming_network --security-opt apparmor=cloudsuitemedia-streamingclient63_profile cloudsuite/media-streaming:client streaming_server
docker run -t --name streaming_client64 -v /output:/output --volumes-from streaming_dataset --net streaming_network --security-opt apparmor=cloudsuitemedia-streamingclient64_profile cloudsuite/media-streaming:client streaming_server
docker stop streaming_server










































































































































