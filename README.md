# Docker Swarm Example

## Without machine
**Pre-requirements:** Create 3 Linux Machines that have Docker Engine running on them.
* Execute on Master Node.
   * `docker swarm init --advertise-addr <host ip>`
      * To create Secondary Master, run command on master to get master token
      * `docker swarm join-token manager`
   * Open the following ports
      * TCP port 2377 for cluster management communications
      * TCP and UDP port 7946 for communication among nodes
      * UDP port 4789 for overlay network traffic


* Execute on Worker Nodes
   * `docker swarm join --token <token> <host ip>:2377`
   * Open the following ports
      * TCP port 2377 for cluster management communications
      * TCP and UDP port 7946 for communication among nodes
      * UDP port 4789 for overlay network traffic


* For Portainer Management GUI Run the Following on Master Nodes
```
docker volume create portainer_data
docker run -d -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer
```
* Running Portainer in the Swarm:
```
docker service create \
--name portainer \
--publish 9000:9000 \
--replicas=1 \
--constraint 'node.role == manager' \
--mount type=bind,src=//var/run/docker.sock,dst=/var/run/docker.sock \
portainer/portainer \
-H unix:///var/run/docker.sock
```
* Access Manager `http://<host ip>:9000/`

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
