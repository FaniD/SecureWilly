#!/bin/sh
yes | docker volume prune
yes | docker-compose rm -v
yes | docker container prune
sudo rm data/*

