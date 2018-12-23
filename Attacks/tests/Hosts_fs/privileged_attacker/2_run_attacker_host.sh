#!/bin/bash

docker run --privileged --pid=host --rm -it debian:latest nsenter --target 1 --mount /bin/bash
