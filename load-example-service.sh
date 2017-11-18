#!/bin/sh
docker load -i example-service.tar
docker tag example-service localhost:5000/example-service
docker push localhost:5000/example-service
#Clean up
docker rmi example-service
rm example-service.tar
rm load-example-service.sh
