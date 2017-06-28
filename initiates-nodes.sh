#!/usr/local/bin/bash

declare -a vars=(DOTOKEN EXISTING_NODES ADD_NODES)

for v in "${vars[@]}"
do
    value=${!v};

    if [ -z $value ]; then
         echo "Missing environment variable $v"
         exit 1
    fi

#    printf "%s=<%s> " "$v" "$value";
done;

for ((i=($EXISTING_NODES + 1); i<=($EXISTING_NODES + $ADD_NODES); i++)); do
  ( docker-machine create --driver digitalocean \
    --digitalocean-image ubuntu-16-04-x64 \
    --digitalocean-region ams2 \
    --digitalocean-size 512mb \
    --digitalocean-private-networking \
    --digitalocean-access-token $DOTOKEN \
    node-$i ) &
done

wait

# setup firewall
# If you are planning on creating an overlay network with encryption (--opt encrypted), you will also need to ensure ip protocol 50 (ESP) traffic is allowed.
# https://www.digitalocean.com/community/tutorials/how-to-configure-the-linux-firewall-for-docker-swarm-on-ubuntu-16-04

#docker-machine ssh node-1 ufw allow 22/tcp
#docker-machine ssh node-1 ufw allow 2376/tcp
#docker-machine ssh node-1 ufw allow 2377/tcp
#docker-machine ssh node-1 ufw allow 7946/tcp
#docker-machine ssh node-1 ufw allow 7946/udp
#docker-machine ssh node-1 ufw allow 4789/udp
#docker-machine ssh node-1 ufw allow 50/tcp
#docker-machine ssh node-1 ufw --force enable
#docker-machine ssh node-1 ufw reload
#
#for ((i=($EXISTING_NODES + 1); i<=($EXISTING_NODES + $ADD_NODES); i++)); do
#  (
#    docker-machine ssh node-$i ufw allow 22/tcp && \
#    docker-machine ssh node-$i ufw allow 2376/tcp && \
#    docker-machine ssh node-$i ufw allow 7946/tcp && \
#    docker-machine ssh node-$i ufw allow 7946/udp && \
#    docker-machine ssh node-$i ufw allow 4789/udp && \
#    docker-machine ssh node-$i ufw allow 50/tcp && \
#    docker-machine ssh node-$i ufw --force enable && \
#    docker-machine ssh node-$i ufw reload
#  ) &
#done

docker-machine ls
docker-machine env node-1
