#!/bin/bash

#Reload profile
. ~/.profile

export SCRIPT_DIR=/afc/ergols/scripts
export LOG_DIR=/afc/ergols/scripts/logs

NOW=$(date +"%Y%m%d%H%M%S")
LOG=$LOG_DIR/auto_shutdb_$NOW.log

stop_service()
{
cchcmd << EOF
init 4
init 3
exit
EOF
}
# ==========================
# M A I N
# ==========================
stop_service >> $LOG







