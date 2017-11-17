#!/bin/bash
set -ue
# If creating machines for Management.
#docker-machine create --driver virtualbox manager1
#docker-machine create --driver virtualbox node2
#docker-machine create --driver virtualbox node3

sudo ufw allow 2377
sudo ufw allow 7946
sudo ufw allow 4789
