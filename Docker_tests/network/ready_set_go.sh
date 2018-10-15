#/bin/bash

sudo rm /etc/apparmor.d/client_profile
rm -r Logs
mkdir Logs
cp profiles/client/version_1 .
rm profiles/client/*
mv version_1 profiles/client/
