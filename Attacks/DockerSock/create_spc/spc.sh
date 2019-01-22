#!/bin/sh

echo "====== Running privileged container ======"
docker run --rm -it --privileged --net=host --ipc=host --uts=host --pid=host -v /:/HostsFS ubuntu 
