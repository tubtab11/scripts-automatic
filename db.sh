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
export ORACLE_SID=BPLTST03
export ORACLE_BASE=/app/oracle
export ORACLE_HOME=/app/oracle/product/server_ee/11.2.0.2
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


stop_lsnrs()
#=======================
{
### Stop TNS normal ###
$ORACLE_INITD/lsnrshut >>$LOG
echo "$(date +"%Y%m%d%H%M%S") :Stop tnslsnr normal" >> $LOG

### Stop TNS Force ###
PROCESS_TNS=$(pgrep tnslsnr |wc -l)
      if [ $PROCESS_TNS -ge 1 ];
                  then pkill -9 tnslsnr
                  echo "$(date +"%Y%m%d%H%M%S") :Stop tnslsnr force" >> $LOG
      fi
}

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

}

force_shut()
{
  ORACLE_SID=`echo $LINE | awk -F: '{print $1}' -`
  if [ "$ORACLE_SID" = '*' ] ; then
    ORACLE_SID=""
  fi
# Called programs use same database ID
export ORACLE_SID
ORACLE_HOME=`echo $LINE | awk -F: '{print $2}' -`
export ORACLE_HOME
# Put $ORACLE_HOME/bin into PATH and export.
PATH=$ORACLE_HOME/bin:/bin:/usr/bin:/etc ; export PATH

PROCESS_PMON=$(ps -ef | grep "pmon" |grep $ORACLE_SID | grep -v "grep" | wc -l)
   if [ $PROCESS_PMON -ge 1 ];
   then
SQLDBA="sqlplus /nolog"
$SQLDBA <<EOF>>$LOG
connect / as sysdba
shutdown abort
quit
EOF
   fi
}

#==========================
# M A I N
#==========================

#### Stop listener #######
stop_lsnrs

#### Kill Pending Process #####
kill_session

#### Stop Database #######
$ORACLE_INITD/dbshut >> $LOG


#### Check Database was down ######
 PROCESS_NUM=$(ps -ef | grep "pmon" | grep -v "grep" | wc -l)

        if [ $PROCESS_NUM -ge 1 ];
        then
        cat $ORATAB | while read LINE
            do
              case $LINE in
              \#*)                ;;        #comment-line in oratab
              *)
              ORACLE_SID=`echo $LINE | awk -F: '{print $1}' -`
              if [ "$ORACLE_SID" = '*' ] ; then
              # NULL SID - ignore
              ORACLE_SID=""
              continue
              fi
              # Proceed only if last field is 'Y' or 'W'
              if [ "`echo $LINE | awk -F: '{print $NF}' -`" = "Y" ] ; then
                 if [ `echo $ORACLE_SID | cut -b 1` != '+' ]; then
                 ORACLE_HOME=`echo $LINE | awk -F: '{print $2}' -`
                 force_shut >> $LOG
                 fi
              fi
              ;;
              esac
            done
        echo "$(date +"%Y%m%d%H%M%S") :SHUTDOWN FORCE" >>$LOG
        exit 0
        else
        echo "$(date +"%Y%m%d%H%M%S") :SHUTDOWN SMOOTH" >>$LOG
        exit 0
        fi