#!/bin/bash
COMPOSE=1.17.1
MACHINE=0.13.0
set -eu
echo "Installing Docker CE"
sudo apt update
sudo apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt update
sudo apt install -y docker-ce
echo "Installing Docker Compose v${COMPOSE}"
sudo curl -L https://github.com/docker/compose/releases/download/${COMPOSE}/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
echo "Installing Docker Machine"
echo "... Installing VirtualBox 5.1 for use with docker-machine driver"
sudo apt install-y virtualbox
echo "... Installing Docker Machine"
sudo curl -L https://github.com/docker/machine/releases/download/v${MACHINE}/docker-machine-`uname -s`-`uname -m` >/tmp/docker-machine
sudo chmod +x /tmp/docker-machine
sudo cp /tmp/docker-machine /usr/local/bin/docker-machine
echo "... Adding Docker Machine Completion"
scripts=( docker-machine-prompt.bash docker-machine-wrapper.bash docker-machine.bash ); for i in "${scripts[@]}"; do sudo wget https://raw.githubusercontent.com/docker/machine/v${MACHINE}/contrib/completion/bash/${i} -P /etc/bash_completion.d; done
