#!/bin/bash

TRANSMISSION_PEERPORT=24331
TRANSMISSION_RPCPORT=2000

set +e
docker stop cordcutter
docker rm cordcutter
set -e

docker run -d --restart always --name cordcutter \
	-e TRANSMISSION_PEERPORT=$TRANSMISSION_PEERPORT \
	-e TRANSMISSION_RPCPORT=$TRANSMISSION_RPCPORT \
	-p $TRANSMISSION_RPCPORT:$TRANSMISSION_RPCPORT -p $TRANSMISSION_PEERPORT:$TRANSMISSION_PEERPORT \
	-p 8090:8090 -p 5299:5299 -p 6789:6789 -p 8989:8989 -p 5050:5050 -p 8181:8181 -p 9117:9117 \
	-v /config:/config \
	-v /Media:/Media \
	-v /etc/localtime:/etc/localtime:ro \
	cordcutter
docker logs -f cordcutter
