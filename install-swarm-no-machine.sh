#!/bin/bash
set -ue
echo "Unblocking Ports on Ubuntu Machine"
sudo ufw allow 2377
sudo ufw allow 7946
sudo ufw allow 4789
