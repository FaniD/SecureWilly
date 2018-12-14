#!/bin/sh

docker run --security-opt "apparmor=attacked_profile" --rm -it debian:latest /bin/bash
