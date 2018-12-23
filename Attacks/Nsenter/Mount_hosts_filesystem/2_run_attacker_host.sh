#!/bin/bash

docker run --privileged --pid=host --rm -it ubuntu:latest nsenter -t 1 -m -p /bin/bash
