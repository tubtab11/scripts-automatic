#!/bin/bash

# Reload profile
. ~/.profile

export SCRIPT_DIR=/export/home/smsadmin/scripts
export LOG_DIR=/export/home/smsadmin/scripts/logs
export PATH_OLS=/afc/ergols/scripts

check_service()
{
    value=`pmstatus.pl | grep 32m | egrep -v  "Process Manager Status" | egrep -v "no response" | cut -d ' ' -f2 | cut -c8-`
    if [ -z "$value" ]; 
    then
        echo "my_var is NULL"
    else
        echo "my_var is NOT NULL"
    fi
 
}
# ==========================
# M A I N
# ==========================
check_service
################################################################################s
