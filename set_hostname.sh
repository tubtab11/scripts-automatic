#!/bin/bash

echo Enter your hostname
read hostname
echo enter Your ip
read ip

svccfg -s system/identity:node setprop config/nodename="$hostname"
svcadm refresh system/identity:node
svcadm restart system/identity:node
echo "$ip        $hostname" >> /etc/hosts
