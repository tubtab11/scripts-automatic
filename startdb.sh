export ORACLE_HOME=/app/oracle/product/server_ee/19.5.0.0
export ORACLE_BASE=/app/oracle
export LD_LIBRARY=$LD_LIBRARY_PATH:$ORACLE_HOME/lib
export PATH=$ORACLE_HOME/bin:$PATH

echo "Enter your database name"
read "Enter your name:"$sid1
#set time variable

export ORACLE_SID=$sid1

#start listener

lsnrctl start

#start database
sqlplus / as sysdba << EOF
startup;
exit;
EOF
