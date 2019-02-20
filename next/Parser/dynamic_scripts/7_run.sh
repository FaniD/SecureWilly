#!/bin/bash
 
docker run test --security-opt apparmor=test_profile -p 4:6
docker run db --security-opt apparmor=db_profile -v a:a
docker run db --security-opt apparmor=db_profile -p 4:4 -p 5:5
docker run test --security-opt apparmor=test_profile --ulimit nofile=1024:1024
docker run test --security-opt apparmor=test_profile -p 80:80 -v a:b --cap-add SYS_CHROOT --cap-drop CHOWN
