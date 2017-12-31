#!/bin/sh

rm ./data/*

#Bring static parser here and produce static profile
cp ../../Parser/static_parser.py .
python static_parser.py Dockerfile docker-compose.yml

#Write profile to apparmor
sudo cp static_profile /etc/apparmor.d
sudo apparmor_parser -r -W /etc/apparmor.d/static_profile

#And now run the container
docker-compose up --build
