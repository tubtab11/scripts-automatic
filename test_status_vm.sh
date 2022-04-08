#!/bin/bash

# Reload profile
. ~/.profile

export SCRIPT_DIR=/export/home/smsadmin/scripts
export LOG_DIR=/export/home/smsadmin/scripts/logs

stop_node()
{
  sudo nodecontrol.sh stop
  echo "$(date +"%Y%m%d%H%M%S") : nodecontrol stop"
}
check_ps()
{
  value=`pmstatus.pl | grep 32m | egrep -v  "Process Manager Status" | egrep -v "no response" | cut -d ' ' -f2 | cut -c8-`
  declare -a my_array
  my_array=($value)

  for ((i=0; i < ${#my_array[@]}; i++ ));
  do
        service_name="${my_array[$i]}"
        sudo pkill -9 $service_name
        echo "kill Service [$service_name]"
        echo "complated\n"

  done
}
shutdown_status()
{
    value=`pmstatus.pl | grep 32m | egrep -v  "Process Manager Status" | egrep -v "no response" | cut -d ' ' -f2 | cut -c8-`
    if [ -z "$value" ]; 
    then
        echo "Service Shutdown Complated"
        exit 0
    else
        echo "Service Shutdown Failed"
        exit 1
    fi
}
# ==========================
# M A I N
# ==========================
stop_node
sleep 1.0
check_ps
sleep 1.0
shutdown_status
################################################################################s
