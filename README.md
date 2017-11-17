# Docker Swarm Example

* Install Docker Machine on 3 VM,
   * curl -L https://github.com/docker/machine/releases/download/v0.13.0/docker-machine-`uname -s`-`uname -m` >/tmp/docker-machine &&
     chmod +x /tmp/docker-machine &&
     sudo cp /tmp/docker-machine /usr/local/bin/docker-machine

* Install Virtualbox for Docker-Machine Driver
   * sudo apt install virtualbox
* `docker-machine ls` to list available machines.
* `docker-machine create --driver virtualbox manager1` to create virtual machine
* `docker-machine ip manager1` to get ip address of docker machine

##Open protocols and ports between the hosts
The following ports must be available. On some systems, these ports are open by default.

* TCP port 2377 for cluster management communications
* TCP and UDP port 7946 for communication among nodes
* UDP port 4789 for overlay network traffic
* If you are planning on creating an overlay network with encryption (--opt encrypted), you will also need to ensure ip protocol 50 (ESP) traffic is allowed.

* https://docs.docker.com/engine/swarm/swarm-tutorial/create-swarm/
* https://docs.docker.com/engine/swarm/swarm-tutorial/add-nodes/
* https://docs.docker.com/engine/swarm/swarm-tutorial/deploy-service/
* https://docs.docker.com/engine/swarm/swarm-tutorial/inspect-service/  

# Begin the Swarm
Open a terminal and ssh into the machine where you want to run your manager node. This tutorial uses a machine named manager1. If you use Docker Machine, you can connect to it via SSH using the following command:
```
$ docker-machine ssh manager1
```

Run the following command to create a new swarm:
```
docker swarm init --advertise-addr <MANAGER-IP>
```
In the tutorial, the following command creates a swarm on the manager1 machine:

```
$ docker swarm init --advertise-addr 192.168.99.100
```
Swarm initialized: current node (dxn1zf6l61qsb1josjja83ngz) is now a manager.

To add a worker to this swarm, run the following command:
```
    docker swarm join \
    --token SWMTKN-1-49nj1cmql0jkz5s954yi3oex3nedyz0fb0xx14ie39trti4wxv-8vxv8rssmk743ojnwacrr2e7c \
    192.168.99.100:2377
```

To add a manager to this swarm, run `docker swarm join-token manager` and follow the instructions.
The --advertise-addr flag configures the manager node to publish its address as 192.168.99.100. The other nodes in the swarm must be able to access the manager at the IP address.

The output includes the commands to join new nodes to the swarm. Nodes will join as managers or workers depending on the value for the --token flag.

Run docker info to view the current state of the swarm:
```
$ docker info
```
Containers: 2
Running: 0
Paused: 0
Stopped: 2
  ...snip...
Swarm: active
  NodeID: dxn1zf6l61qsb1josjja83ngz
  Is Manager: true
  Managers: 1
  Nodes: 1
  ...snip...

Run the docker node ls command to view information about nodes:
```
$ docker node ls
```
ID                           HOSTNAME  STATUS  AVAILABILITY  MANAGER STATUS
dxn1zf6l61qsb1josjja83ngz *  manager1  Ready   Active        Leader

The * next to the node ID indicates that you’re currently connected on this node.

