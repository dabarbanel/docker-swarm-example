#!/bin/bash
MACHINE_NAME=${1-"swarm-master"}
set -ue
echo "Creating Virtual Machines using Virtualbox Driver"
docker-machine create --driver virtualbox swarm-master
docker-machine create --driver virtualbox swarm-node-01
docker-machine create --driver virtualbox swarm-node-02
docker-machine scp -r create-master-services.sh ${MACHINE_NAME}:/home/docker/create-master-services.sh
