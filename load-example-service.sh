#!/bin/sh
docker load -i example-service.tar
docker tag example-service localhost:5000/example-service
docker push localhost:5000/example-service
#Clean up
docker rmi example-service
rm example-service.tar
rm load-example-service.sh
#Start The Stack
docker stack deploy --compose-file docker-compose.yml stackdemo
echo "************************************************************************"
echo ""
echo "`curl http://localhost:8000` - Test Running Service"
echo "`docker stack rm stackdemo` - To Stop Running Stack"
echo "`docker stack deploy --compose-file docker-compose.yml stackdemo` - To start stack again"
echo ""
echo "************************************************************************"
