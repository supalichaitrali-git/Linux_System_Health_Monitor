#!/bin/bash

#==========================================================================
# Project : Linux System Health Monitor
# Author  : Chaitrali Supali
# Purpose : Monitor important Linux system health information
# Version : 1.0
#==========================================================================

HOSTNAME=$(hostname)
CURRENT_DATE=$(date)
UPTIME=$(uptime -p)

echo "====================================================================="
echo "Linux System Health Monitor"
echo "====================================================================="

echo 
echo "=========SYSTEM INFORMATION========="
echo "Hostname : $HOSTNAME"
echo "Date     : $CURRENT_DATE"
echo "Uptime   : $UPTIME"
echo 

