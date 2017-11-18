#!/bin/bash
set -eu
MACHINE_NAME=${1-"swarm-master"}
(cd example-service
docker build -t example-service .
docker save example-service > example-service.tar
docker-machine scp -r example-service.tar ${MACHINE_NAME}:/home/docker/example-service.tar
#Clean up
docker rmi example-service
rm example-service.tar)
docker-machine scp -r load-example-service.sh ${MACHINE_NAME}:/home/docker/load-example-service.sh
docker-machine scp -r docker-compose.yml ${MACHINE_NAME}:/home/docker/docker-compose.yml
docker-machine ssh ${MACHINE_NAME}
