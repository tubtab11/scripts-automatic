#!/bin/bash
#####################################################
# Remote shutdown non-global zones
# Script name : OFS_Remote_Shutdown_Zone.sh
# Version  Date      Who             What
# -------- --------- --------------- ----------------
# 1.0.0    11 Sep 18 BPS Infra Team  Initial Release
#####################################################

#Reload profile
. ~/.profile
#Halt all non-global zone
for i in `zoneadm list -v | awk '{print $2}'| grep -v NAME | grep -v global`
do
  #echo $i
  zoneadm -z $i halt
done

#Check have only one global zone
chk_zone=`zoneadm list -v | awk '{print $2}'| grep -v NAME`
if [ $chk_zone == "global" ]; then
  #shutdown non-zone completed
  echo "shutdown non-zone completed $chk_zone "
  exit 0 
else
  #shutdown non-zone not completed
  echo "shutdown non-zone not completed $chk_zone"
  exit 1 
fi
#####################################################