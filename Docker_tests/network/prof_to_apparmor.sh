#!/bin/sh
sudo cp net_profile /etc/apparmor.d/
sudo apparmor_parser -r -W /etc/apparmor.d/net_profile
