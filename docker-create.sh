#!/bin/bash

docker ps -l -q -f "name=cordcutter" | xargs -n1 -r docker stop
docker ps -l -q -f "name=cordcutter" | xargs -n1 -r docker rm
docker images -q cordcutter | xargs -n1 -r docker rmi
docker build -t cordcutter:latest .
