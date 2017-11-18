#!/bin/sh
echo "Creating Docker Registry Service"
docker service create --name registry --publish 5000:5000 registry:2
echo "Creating Portainer Service"
docker service create \
--name portainer \
--publish 9000:9000 \
--replicas=1 \
--constraint 'node.role == manager' \
--mount type=bind,src=//var/run/docker.sock,dst=/var/run/docker.sock \
portainer/portainer \
-H unix:///var/run/docker.sock
#Clean itself up
rm create-master-services.sh
