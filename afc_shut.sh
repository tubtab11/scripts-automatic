#!/bin/bash

#Reload profile
. ~/.profile

export SCRIPT_DIR=/root/scripts/
export LOG_DIR=/root/scripts/logs

stop_node()
{
        nodecontrol.sh stop 
        echo "$(date +"%Y%m%d%H%M%S") : nodecontrol stop"
}
check_ps()
{
        value=`pmstatus.pl | grep 32m | egrep -v  "Process Manager Status" | egrep -v "no response" | cut -d ' ' -f2 | cut -c8-`
        #echo $value
        declare -a my_array
        my_array=($value)

        for ((i=0; i < ${#my_array[@]}; i++ ));
        do
                a="${my_array[$i]}"
                #echo "$a"
                #ps -ef | grep $a
                service_name="$a"
                pkill -9 $service_name
                echo "kill Service [$service_name]"
                echo "complated\n"

        done
        #a=${#my_array[@]};
        #echo "$a"
        #ps -ef | grep $a
}
# ==========================
# M A I N
# ==========================
stop_node
sleep 10
check_ps
