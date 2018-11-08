#!/bin/sh
#Build & run manually, because docker-compose up does not support interactive
docker-compose build ulim
docker-compose run ulim
