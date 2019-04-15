#!/bin/bash

#Count time while running Nextcloud unconfined
time (./test_plan.sh) 2> unconfined
cat unconfined >> time_nc

#Clear network, images, volume
./clear_docker.sh

