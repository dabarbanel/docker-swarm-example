# Docker Swarm Example

## File Explanations
* **setup.sh** - Installs docker-machine and virtualbox for single host testing
* **install-swarm-no-machine.sh** - Opens TCP Ports on Ubuntu Machine
* **install-swarm-vb-driver.sh** - (For Use with Virtualbox Driver) - Creates 3 docker machines using VB driver and copies into master node create-master-services.sh
* **create-master-services.sh** - Loads Docker Registry and Portainer Services, then self destructs.
* **add-example-service** - (For Use with Virtualbox Driver) - Adds example python image and load-example-service.sh into the master-node or specified machine NAME.
* **load-example-service.sh** - (For Use with Virtualbox Driver) - Loads example service into Docker Registry Service and self destructs
* **notes** - Research to possibly use later
* **ubuntu-16.04-fix-vb.sh** - Used to fix Kernel problem when attempting to install virtualbox on Ubuntu 16.04

## Without machine
**Pre-requirements:** Create 3 Linux Machines that have Docker Engine running on them.
* Execute on Master Node.
   * `docker swarm init --advertise-addr <master node ip>`
      * To create Secondary Master, run command on master to get master token
      * `docker swarm join-token manager`
   * `install-swarm-no-machine.sh` on ubuntu Machines, it opens ports below
      * Open the following ports
         * TCP port 2377 for cluster management communications
         * TCP and UDP port 7946 for communication among nodes
         * UDP port 4789 for overlay network traffic


* Execute on Worker Nodes
   * `docker swarm join --token <token> <master node ip>:2377`
   * `install-swarm-no-machine.sh` on ubuntu Machines, it opens ports below
      * Open the following ports
         * TCP port 2377 for cluster management communications
         * TCP and UDP port 7946 for communication among nodes
         * UDP port 4789 for overlay network traffic

* `add-example-service.sh` to create Docker Registry and Run Portainer services
* Access UI Manager `http://<Master Node Ip>:9000/`

* If you prefer to just use the Docker Visualizer you would run this in the swarm.
```
docker service create \
  --name=viz \
  --publish=8080:8080/tcp \
  --constraint=node.role==manager \
  --mount=type=bind,src=/var/run/docker.sock,dst=/var/run/docker.sock \
  dockersamples/visualizer
```

## Using Docker Machine

* Run `setup.sh`
* Run `install-swarm-vb-driver.sh`
* List Docker Machine `docker-machine ls`
```
NAME            ACTIVE   DRIVER       STATE     URL                         SWARM   DOCKER        ERRORS
swarm-master    -        virtualbox   Running   tcp://192.168.99.100:2376           v17.10.0-ce   
swarm-node-01   -        virtualbox   Running   tcp://192.168.99.101:2376           v17.10.0-ce   
swarm-node-02   -        virtualbox   Running   tcp://192.168.99.102:2376           v17.10.0-ce  
```
* To get IP from running Docker Machine `docker-machine ip <name>`
* Next Shell into each Docker Machine and complete the Without Machine Steps
   * `docker-machine ssh <name>`

## Create Docker Registry in SWARM
* `docker service create --name registry --publish 5000:5000 registry:2`

## Useful Commands

* Run docker info to view the current state of the swarm:
   * `docker info`
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
```

* Run the docker node ls command to view information about nodes:
   * `docker node ls`

```
ID                           HOSTNAME  STATUS  AVAILABILITY  MANAGER STATUS
dxn1zf6l61qsb1josjja83ngz *  manager1  Ready   Active        Leader

The * next to the node ID indicates that you’re currently connected on this node.
```

* `docker-machine ls` - List Docker Machines
* `docker-machine ip <machine name>` - Get IP address of Docker Machine
* `docker-machine ssh <machinename>` - SSH into Docker Machine
* `docker-machine scp -r <localFile> <machinename>:<pathToRemoteFile>` - Copy file into Docker Machine
* `docker swarm init --advertise-addr <manager ip>` - Create Swarm
* `docker info` - Get Current State of Swarm
* `docker node ls` - List connected Nodes
* `docker service create --replicas 1 --name <name> <container> <parameters>` * Creates a Swarm Service
* `docker service create --name <SERVICE-NAME> --publish <PUBLISHED-PORT>:<TARGET-PORT> <IMAGE>` - create a Swarm Service mapped to port
* `docker service ls` - List of running services
* `docker service inspect --pretty <name>` - Gets details on a service "--pretty displays info in yaml, without is JSON"
* `docker service ps <name>` - See which node is running service.
* `docker ps` - Execute on working node to see details
* `docker service scale <name>=<number of tasks>` - Scale a service across nodes.
* `docker service rm <name>` - remove the service
* `docker service update --image <imagename> <service-name>` - Update running service
* `docker service update --publish-add <PUBLISHED-PORT>:<TARGET-PORT> <service-name>` - Update port on running service
