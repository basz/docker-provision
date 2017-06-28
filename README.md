
must have ansible 2.3+


1\. Spin up a few nodes at digital ocean

```
DOTOKEN=token EXISTING_NODES=0 ADD_NODES=2 ./initiate-nodes.sh
```

2\. Configure shell

```
eval $(docker-machine env node-1)
```
3\. Add IP adrresses to inventory-production.yml

4\. Run in the this order

```
ansible-playbook -i inventory-production.yml plays/infrastructure/provision-nodes.yml && \
ansible-playbook -i inventory-production.yml plays/infrastructure/create-swarm.yml && \
ansible-playbook -i inventory-production.yml plays/infrastructure/deploy-stacks.yml
```

tada...

swarm with 2 nodes called node-1 (manager) and node-2

problem 1

```
# has correct password - user, pass
open "http://$(docker-machine ip node-1)/admin?stats"

# has default password - admin, admin
open "http://$(docker-machine ip node-2)/admin?stats"
```

problem 2

unreliability, seen "Docker Flow Proxy: 503 Service Unavailable", to standard "503 Service Unavailable", once I got "hello world".

clues:

repeated log messages:
Creating configuration for the service hello-world_main

also tried without stacks as shown on docker-flow-proxy website.

```
docker node ps

ID            NAME                        IMAGE                                      NODE    DESIRED STATE  CURRENT STATE              ERROR                      PORTS
3j2fzdt6jfm2  proxy_swarm-listener.1      vfarcic/docker-flow-swarm-listener:latest  node-1  Running        Running 4 seconds ago                                 
xw71t6cqfxae   \_ proxy_swarm-listener.1  vfarcic/docker-flow-swarm-listener:latest  node-1  Shutdown       Failed 10 seconds ago      "task: non-zero exit (2)"  
yt6xexzvkn4e   \_ proxy_swarm-listener.1  vfarcic/docker-flow-swarm-listener:latest  node-1  Shutdown       Failed 24 seconds ago      "task: non-zero exit (2)"  
lspsy7f6xizy   \_ proxy_swarm-listener.1  vfarcic/docker-flow-swarm-listener:latest  node-1  Shutdown       Failed 38 seconds ago      "task: non-zero exit (2)"  
jxb545029k9x   \_ proxy_swarm-listener.1  vfarcic/docker-flow-swarm-listener:latest  node-1  Shutdown       Failed 52 seconds ago      "task: non-zero exit (2)"  
b3oxl6dz64ly  hello-world_main.1          vfarcic/go-demo:latest                     node-1  Shutdown       Failed about an hour ago   "task: non-zero exit (2)"  
j9fofvtso48o   \_ hello-world_main.1      vfarcic/go-demo:latest                     node-1  Shutdown       Failed about an hour ago   "task: non-zero exit (2)"  
i9a5j5meel9d   \_ hello-world_main.1      vfarcic/go-demo:latest                     node-1  Shutdown       Failed about an hour ago   "task: non-zero exit (2)"  
qd3bbk81focy   \_ hello-world_main.1      vfarcic/go-demo:latest                     node-1  Shutdown       Failed about an hour ago   "task: non-zero exit (2)"  
z3vcer479mhm  proxy_proxy.2               vfarcic/docker-flow-proxy:latest           node-1  Running        Running about an hour ago                             
```

swarm-listener keeps restarting "signal SIGSEGV"