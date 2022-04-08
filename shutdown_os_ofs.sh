#!/bin/bash
#####################################################
# Remote shutdown SunOS
# Script name : OFS_Remote_Shutdown_OS.sh
# Version  Date      Who             What
# -------- --------- --------------- ----------------
# 1.0.0    11 Sep 18 BPS Infra Team  Initial Release
#####################################################

#Reload profile
. ~/.profile
#Shutdown Solaris OS
init 5
#Return exit code
exit 0
####################################################