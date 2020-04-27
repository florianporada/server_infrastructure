#!/bin/bash

set -e

echo 'Enter infrastructure directory'
cd /www/docker/server_infrastructure/

echo 'Update docker-compose environment'
docker-compose stop
docker-compose rm -f
docker-compose pull
docker-compose up -d

echo 'Done!'
