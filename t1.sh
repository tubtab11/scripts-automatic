
#!/usr/bin/bash

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

# cdg="cdgrqstsvr"
# swd="switchd"
# cslo="cslogd"
#NOW=$(date +"%Y%m%d%H%M%S")
#LOG=$LOG_DIR/auto_shutApp_$NOW.log
# LOG1=$LOG_DIR1/auto_checknodeh_$NOW.log

# Shutdown Nodespace
# nodecontrol.sh stop >>$LOG
# echo "$(date +"%Y%m%d%H%M%S") :" nodecontrol stop >> $LOG
# Check nodehealt
# nodehealth.sh >>$LOG1
# echo "$(date +"%Y%m%d%H%M%S") :"  nodehealt not running >> $LOG1
stop_node()
{
    #nodecontrol.sh stop >>$LOG
    #echo "$(date +"%Y%m%d%H%M%S") : nodecontrol stop"
    #echo "$(date +"%Y%m%d%H%M%S") :" nodecontrol stop >> $LOG
    running_service_number=`pmstatus.pl | egrep -v  "Process Manager Status" | grep 3 | wc -l`
    echo $running_service_number
    value=`pmstatus.pl | egrep -v  "Process Manager Status" | grep 3 | head -n $running_service_number | cut -d ' ' -f2`
    echo $value

    declare -a my_array
    my_array=($value)

    for ((i=0; i < ${#my_array[@]}; i++ ));
    do
      service_name="${my_array[$i]}";
      ps -ef | grep "$service_name" 
    done
}
# check_cdg()
# {
#     export varion

#     for  i in `ps -ef | grep $varion |wc -l`
#     do
#         #echo $i
#         if [ $i -gt 1 ]; then
#         echo "not completed"
#         echo "kill"
#         pkill -9 $varion
#         else
#         echo "$NOW  $varion Not Running"
#         fi
#     done
# }
# check_swd()
# {
#     for i in `ps -ef | grep $swd |wc -l`
#     do
#         #echo $i
#         if [ $i -gt 1 ]; then
#         echo "not completed"
#         echo "kill"
#         pkill -9 $swd
#         else
#         echo "$NOW switchd Not Running"
#         fi
#     done
# }
# check_csl()
# {
#     for i in `ps -ef | grep $cslog |wc -l`
#     do
#         #echo $i
#         if [ $i -gt 1 ]; then
#         echo "not completed"
#         echo "kill"
#         pkill -9 $cslo
#         else
#         echo "$NOW cslogd Not Running"
#         fi
#     done
# }
# ==========================
# M A I N
# ==========================
stop_node
