#!/bin/bash

if [ "$1" = "bash" ]; then
  exec $@
else
  cd /root/run && exec ./benchmark.sh $1
fi
