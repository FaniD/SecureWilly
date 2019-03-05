#!/bin/sh
#And now run the container
docker build . -t ports_well_known_genprof
docker run --security-opt "apparmor:genprof_profile" -p "8887:88" ports_well_known_genprof

