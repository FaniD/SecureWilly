#!/bin/sh
#And now run the container
docker rm dockerimage_foo_1
docker rmi dockerimage_foo
docker-compose up --build
