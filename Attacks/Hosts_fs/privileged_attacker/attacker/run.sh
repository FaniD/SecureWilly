#!/bin/bash

docker build -t attacker .
docker run --privileged --pid=host --rm -it attacker
