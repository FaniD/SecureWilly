#!/bin/sh

rm -r ../parser_output
rm if*
docker kill nextcloud
docker kill db
docker rm nextcloud
docker rm db
docker volume prune
