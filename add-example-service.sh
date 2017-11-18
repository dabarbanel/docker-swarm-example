#!/bin/bash
MACHINE_NAME=${1-"swarm-master"}
(cd example-service
docker build -t example-service .
docker save example-service > example-service.tar
docker-machine scp -r example-service.tar ${MACHINE_NAME}:/home/docker/example-service.tar
#Clean up
rm example-service.tar)
docker-machine scp -r load-example-service.sh ${MACHINE_NAME}:/home/docker/load-example-service.sh
docker-machine ssh ${MACHINE_NAME}
