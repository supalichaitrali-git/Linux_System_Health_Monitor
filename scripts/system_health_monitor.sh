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

TOTAL_MEMORY=$(free -h | awk 'NR==2 {print $2}')
USED_MEMORY=$(free -h | awk 'NR==2 {print $3}')
FREE_MEMORY=$(free -h | awk 'NR==2 {print $4}')
AVAILABLE_MEMORY=$(free -h |awk 'NR==2 {print $7}')

CPU_ARCHITECTURE=$(lscpu | grep "Architecture" | awk '{print $2}')
CPU_COUNT=$(lscpu | grep "^CPU(s): " | awk '{print $2}')
CPU_MODEL=$(lscpu | grep "Model name" | cut -d':' -f2 | xargs)

TOTAL_DISK=$(df  -h | awk  'NR==2 {print $2}')
USED_DISK=$(df -h | awk 'NR==2 {print $3}')
AVAILABLE_DISK=$(df -h | awk 'NR==2 {print $4}')
DISK_USAGE=$(df -h | awk 'NR==2 {print $5}')

echo "====================================================================="
echo "Linux System Health Monitor"
echo "====================================================================="

echo 
echo "=========SYSTEM INFORMATION========="
echo "Hostname : $HOSTNAME"
echo "Date     : $CURRENT_DATE"
echo "Uptime   : $UPTIME"
echo 

echo "=========MEMORY INFORMATION========="
echo "TOTAL MEMORY     : $TOTAL_MEMORY"
echo "USED MEMORY      : $USED_MEMORY"
echo "FREE MEMORY      : $FREE_MEMORY"
echo "AVAILABLE MEMORY : $AVAILABLE_MEMORY"
echo

echo "=============CPU INFORMATION=========="
echo "Architecture : $CPU_ARCHITECTURE"
echo "CPU Count : $CPU_COUNT"
echo "CPU Model : $CPU_MODEL"
echo

echo "==============DISK INFORMATION==========="
echo "Total Disk     : $TOTAL_DISK"
echo "Used Disk      : $USED_DISK"
echo "Available Disk : $AVAILABLE_DISK"
echo "Disk Usage     : $DISK_USAGE"




