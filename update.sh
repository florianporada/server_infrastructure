#!/bin/bash

set -e

echo 'Enter infrastructure directory'
cd /www/docker/server_infrastructure/

# TODO: add dynamic docker-compose file builder
# echo 'Stop container(s)'

# echo 'Update container(s)'

# echo 'Restart container(s)'

echo 'Update docker-compose environment'
docker-compose stop
docker-compose rm -f
docker-compose pull
docker-compose up -d --remove-orphans

echo 'Done!'
