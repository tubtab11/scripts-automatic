#!/bin/bash

#Reload profile
. ~/.profile

export SCRIPT_DIR=/root/scripts/
export LOG_DIR=/root/scripts/logs


stop_node()
{
    value=`pmstatus.pl | grep 32m | egrep -v  "Process Manager Status" | egrep -v "no response" | cut -d ' ' -f2 | cut -c8-`
    declare -a my_array
    my_array=($value)
    for ((i=0; i < ${#my_array[@]}; i++ ));
    do
    a="${my_array[$i]}"
    service_name=$a
    done

        for item in `ps -ef | grep $service_name| grep -v grep | awk '{print $2}'`
        do  
            echo "$item"
            if [ $item -gt 1 ]; then
            echo "not completed"
            echo "kill\n"
            kill -9 $item
            else
            echo "$ Not Running"
            fi
        done
}
# ==========================
# M A I N
# ==========================
stop_node