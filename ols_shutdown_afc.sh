#!/bin/bash

#Reload profile
. ~/.profile

export SCRIPT_DIR=/afc/ergols/scripts
export LOG_DIR=/afc/ergols/scripts/logs

NOW=$(date +"%Y%m%d%H%M%S")
LOG=$LOG_DIR/auto_shutdb_$NOW.log

stop_service()
{
    ols stop
    echo "$(date +"%Y%m%d%H%M%S") : nodecontrol stop" >> $LOG
}

# ==========================
# M A I N
# ==========================
stop_service







