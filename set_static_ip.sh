#!/bin/bash

echo "Enter Your IP AND SUBNET such 172.17.0.22/24"
read  ipconf

echo "Enter Your IP Gateway"
read  ipgateway

ipadm delete-addr net0/v4
ipadm create-addr -T static -a $ipconf net0/v4
route -p add default $ipgateway 
svcadm enable svc:/network/physical:default
svcadm restart svc:/network/physical:default