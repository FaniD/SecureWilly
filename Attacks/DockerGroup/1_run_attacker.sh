#!/bin/sh

docker build . -t docgroup
docker run --rm -it -v /bin/:/attack_bin docgroup

