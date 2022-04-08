#!/bin/bash

#####################################################
# Remote shutdown Application
# Script name : OFS_Remote_Shutdown_Application.sh
# Version  Date      Who  Nattapon       What
# -------- --------- --------------- ----------------
# 1.0.0    06 Jun 2022 BPS Infra Team  Initial Release
#####################################################
#Reload profile
. ~/.profile

export SCRIPT_DIR=/root/scripts/
export LOG_DIR=/root/scripts/logs
export LOG_DIR1=/root/scripts/nodehealt_logs



check_cdg()
{
    for i in `ps -ef | grep cdgrqstsvr |wc -l`
    do
        #echo $i
        if [ $i -gt 1 ]; then
        echo "not completed"
        echo "kill"
        pkill -9 cdgrqstsvr
        else 
        echo "Not Running"
        fi 
    done
}
check_swd()
{
    for i in `ps -ef | grep switchd |wc -l`
    do
        #echo $i
        if [ $i -gt 1 ]; then
        echo "not completed"
        echo "kill"
        pkill -9 switchd
        echo "not completed"
        else 
        echo "Not Running"
        fi 
    done
}
check_csl()
{
    for i in `ps -ef | grep cslogd |wc -l`
    do
        #echo $i
        if [ $i -gt 1 ]; then
        echo "not completed"
        echo "kill"
        pkill -9 cslogd
        echo "not completed"
        else 
        echo "Not Running"
        fi 
    done
}
#==========================
# M A I N
#==========================
#### check_pm #######
check_cdg
sleep 2
check_swd
sleep 2
check_csl
sleep 2

