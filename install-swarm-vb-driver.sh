#!/bin/bash
set -ue
echo "Creating Virtual Machines using Virtualbox Driver"
docker-machine create --driver virtualbox swarm-master
docker-machine create --driver virtualbox swarm-node-01
docker-machine create --driver virtualbox swarm-node-02
