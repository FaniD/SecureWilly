#!/bin/sh

sudo cp profiles/client/output_client_profile /etc/apparmor.d/net_profile
#After copying this file vim the /etc/apparmor.d/net_profile and change client_profile to net_profile
sudo apparmor_parser -r -W /etc/apparmor.d/net_profile
