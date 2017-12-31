#!/bin/sh
docker build -t test .
docker run -t -i test
