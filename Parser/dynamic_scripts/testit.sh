#!/bin/bash

service_list=(server client)
for SERVICE in "${service_list[@]}"; do
	sudo cp ../output/${SERVICE}_profile .
done
