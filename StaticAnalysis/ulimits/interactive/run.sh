#!/bin/sh
#Build & run manually, because docker-compose up does not support interactive
docker-compose build ulim_ti
docker-compose run ulim_ti
