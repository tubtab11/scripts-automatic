#!/bin/bash

#Reload profile
. ~/.profile

export SCRIPT_DIR=/root/scripts/
export LOG_DIR=/root/scripts/logs
export PATH_OLS=/afc/ergols/scripts

stop_node()
{
  sudo -u ols $PATH_OLS ols stop  
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
# ==========================
# M A I N
# ==========================
stop_node
sleep 10
check_ps
#################################################################################s
