#!/bin/sh
docker build -t dockerfile_example .
docker run -t -i dockerfile_example
