!/bin/bash

####################################################
Remote shutdown Application
Script name : OFS_Remote_Shutdown_Application.sh
Version  Date      Who  Nattapon       What
-------- --------- --------------- ----------------
1.0.0    06 Jun 2022 BPS Infra Team  Initial Release
####################################################
Reload profile
. ~/.profile

export SCRIPT_DIR=/root/scripts/
export LOG_DIR=/root/scripts/logs
export LOG_DIR1=/root/scripts/nodehealt_logs

cdg="cdgrqstsvr"
swd="switchd"
cslo="cslogd"
NOW=$(date +"%Y%m%d%H%M%S")
LOG=$LOG_DIR/auto_shutApp_$NOW.log
LOG1=$LOG_DIR1/auto_checknodeh_$NOW.log

Shutdown Nodespace
nodecontrol.sh stop >>$LOG
echo "$(date +"%Y%m%d%H%M%S") :" nodecontrol stop >> $LOG
Check nodehealt
nodehealth.sh >>$LOG1
echo "$(date +"%Y%m%d%H%M%S") :"  nodehealt not running >> $LOG1
stop_node()
{
    nodecontrol.sh stop >>$LOG
    echo "$(date +"%Y%m%d%H%M%S") : nodecontrol stop"
    echo "$(date +"%Y%m%d%H%M%S") :" nodecontrol stop >> $LOG
   
}
check_cdg()
{
    
    for  i in `ps -ef | grep $cdg `
    do
        echo $i
        if [ $i -gt 1 ]; then
        echo "not completed"
        echo "kill"
        pkill -9 $cdg
        else
        echo "$NOW Not Running"
        fi
    done
}
check_swd()
{
    for i in `ps -ef | grep $swd |wc -l`
    do
        #echo $i
        if [ $i -gt 1 ]; then
        echo "not completed"
        echo "kill"
        pkill -9 $swd
        else
        echo "$NOW switchd Not Running"
        fi
    done
}
check_csl()
{
    for i in `ps -ef | grep $cslo |wc -l`
    do
        #echo $i
        if [ $i -gt 1 ]; then
        echo "not completed"
        echo "kill"
        pkill -9 $cslo
        else
        echo "$NOW cslogd Not Running"
        fi
    done
}
# ==========================
# M A I N
# ==========================
stop_node
check_cdg
check_swd
check_csl