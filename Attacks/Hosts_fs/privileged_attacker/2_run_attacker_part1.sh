#!/bin/bash

docker build -t attacker attacker/
docker run --privileged --pid=host --rm -it attacker
