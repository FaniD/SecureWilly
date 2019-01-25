#!/bin/sh

## from different shell - on the host" > nsenter_trick_host.sh
sudo docker cp nsenter:/util-linux/nsenter /usr/local/bin/
sudo docker cp nsenter:/util-linux/bash-completion/nsenter /etc/bash_completion.d/nsenter


