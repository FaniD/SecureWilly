#!/bin/bash

docker kill nextcloudpi
docker rm nextcloudpi
docker volume rm ncdata

# sudo rm -r parser_output
sudo rm Parser/test_*
