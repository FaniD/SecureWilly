#!/bin/bash

set -e

echo "Prune volumes"
docker volume prune -f

