#!/bin/bash
#
# Program  : remote_shutdown_oracledb.sh
#
# Purpose  : The purpose of this script will shutdown all databases listed in the oratab file
#
#            1.) Input parameter no need
#            2.) Stop listener
#            3.) Kill pending process
#            4.) Stop Database
#            5.) return status 0 completed.
# Change History:
#
# Version  Date      Who      What
# -------- --------- -------- ----------------------------------------------------------------------
# 1.0.0    11 Sep 18 NatthawutP  Initial Release
#
#
. ~/.profile

##### Environment Variable, User must configure to match with the target oracle server. ####
export ORACLE_SID=EBMQA01
export ORACLE_BASE=/app/oracle
export ORACLE_HOME=/app/oracle/product/server_ee/19.5.0.0
export PATH=$PATH:$ORACLE_HOME/bin
export ORATAB=/var/opt/oracle/oratab
export TMP=/tmp

export SCRIPT_DIR=$ORACLE_BASE/admin/$ORACLE_SID/scripts/
export LOG_DIR=$ORACLE_BASE/admin/$ORACLE_SID/scripts/logs

############################################################################################

NOW=$(date +"%Y%m%d%H%M%S")
TMP_ACTIVE_SESS_FILE=$TMP/kill_active_session.sql
LOG=$LOG_DIR/auto_shutdb_$NOW.log
ORACLE_INITD=/app/oracle/ofsdb/init.d

kill_session()
#========================
## Function Kill Pending User on Database ##
{
rm -f $TMP_ACTIVE_SESS_FILE
sqlplus -s /nolog <<EOF>$TMP_ACTIVE_SESS_FILE
set echo on
set feedback off
set define off
set linesize 500
set pagesize 800
set sqlprompt ''
set heading off
--set sqlnumber off
connect / as sysdba
SELECT 'ALTER SYSTEM KILL SESSION '||''''|| s.SID||','||s.SERIAL#||''''||';' as script
FROM gv\$session s
WHERE s.STATUS = 'ACTIVE'
and s.username is not null
and s.username not in ('SYS','SYSTEM');
exit;
EOF

sqlplus -s "/as sysdba" < $TMP_ACTIVE_SESS_FILE >> $LOG
echo "$LOG"
}

# ==========================
# M A I N
# ==========================
kill_session