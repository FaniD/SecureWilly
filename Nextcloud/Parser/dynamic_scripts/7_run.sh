#!/bin/sh

docker-compose up -d
sudo touch /var/lib/docker/volumes/nextcloud_nextcloud/_data/notInitialized
sudo rsync -r /var/lib/docker/volumes/nextcloud_nextcloud/_data container:nextcloud_securewilly
sudo rm -f /var/lib/docker/volumes/nextcloud_nextcloud/_data/notInitialized
./testplan.sh
