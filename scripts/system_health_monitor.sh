#!/bin/bash

#==========================================================================
# Project : Linux System Health Monitor
# Author  : Chaitrali Supali
# Purpose : Monitor important Linux system health information
# Version : 1.0
#==========================================================================

echo
echo "====================================================================="
echo "Linux System Health Monitor"
echo "====================================================================="
# Displays basic system information.
system_information(){
    HOSTNAME=$(hostname)
    CURRENT_DATE=$(date)
    UPTIME=$(uptime -p)
    echo
    echo "=========SYSTEM INFORMATION========="
    echo "Hostname : $HOSTNAME"
    echo "Date     : $CURRENT_DATE"
    echo "Uptime   : $UPTIME"
    echo 
}
 
# Displays memory information.
memory_information(){
    TOTAL_MEMORY=$(free -h | awk 'NR==2 {print $2}')
    USED_MEMORY=$(free -h | awk 'NR==2 {print $3}')
    FREE_MEMORY=$(free -h | awk 'NR==2 {print $4}')
    AVAILABLE_MEMORY=$(free -h |awk 'NR==2 {print $7}')
    echo
    echo "=========MEMORY INFORMATION========="
    echo "TOTAL MEMORY     : $TOTAL_MEMORY"
    echo "USED MEMORY      : $USED_MEMORY"
    echo "FREE MEMORY      : $FREE_MEMORY"
    echo "AVAILABLE MEMORY : $AVAILABLE_MEMORY"
    echo
}
# Displays CPU information.
cpu_information(){
    CPU_ARCHITECTURE=$(lscpu | grep "Architecture" | awk '{print $2}')
    CPU_COUNT=$(lscpu | grep "^CPU(s): " | awk '{print $2}')
    CPU_MODEL=$(lscpu | grep "Model name" | cut -d':' -f2 | xargs)
    echo
    echo "=============CPU INFORMATION=========="
    echo "Architecture : $CPU_ARCHITECTURE"
    echo "CPU Count : $CPU_COUNT"
    echo "CPU Model : $CPU_MODEL"
    echo
}
# Displays disk information.
disk_information(){
    TOTAL_DISK=$(df  -h / | awk  'NR==2 {print $2}')
    USED_DISK=$(df -h / | awk 'NR==2 {print $3}')
    AVAILABLE_DISK=$(df -h / | awk 'NR==2 {print $4}')
    DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}')
    echo
    echo "==============DISK INFORMATION==========="
    echo "Total Disk     : $TOTAL_DISK"
    echo "Used Disk      : $USED_DISK"
    echo "Available Disk : $AVAILABLE_DISK"
    echo "Disk Usage     : $DISK_USAGE"
    echo 
    echo "=============DISK HEALTH================"
    DISK_USAGE_NUM=${DISK_USAGE%\%}
    if [ "$DISK_USAGE_NUM" -gt 80 ] 
    then
        echo "Status : WARNING "
    else
        echo "Status : HEALTHY "
    fi
    echo
}
# Displays user information.
user_information(){
    CURRENT_USER=$(whoami)
    USER_ID=$(id -u)
    PRIMARY_GROUP=$(id -gn)
    echo
    echo "===================USER INFORMATION================="
    echo "Current User : $CURRENT_USER"
    echo "User ID : $USER_ID"
    echo "Primary Group : $PRIMARY_GROUP"
    echo
}
# Displays process information.
process_information(){
    TOTAL_PROCESSES=$(ps -e --no-headers |wc -l)
    TOP_PROCESSES=$(ps -ef | head -5)
    echo
    echo "======================RUNNING  PROCESSES================="
    echo "Total Running Processes : $TOTAL_PROCESSES"
    echo "TOP PROCESSES : $TOP_PROCESSES"
    echo
}
# Displays load average.
load_average(){
    LOAD_AVERAGE=$(uptime | awk -F'load average: ' '{print $2}')
    echo
    echo "================LOAD AVERAGE==============="
    echo "Load Average (1, 5, 15 min) : $LOAD_AVERAGE"
    echo
}
# Displays network information.
network_information(){
    IP_ADDRESS=$(hostname -I)
    INTERFACE=$(ip -br addr | grep "eth0" | awk '{print $1}')
    INTERFACE_STATUS=$(ip -br addr | grep "eth0" | awk '{print $2}')
    DEFAULT_GATEWAY=$(ip route | grep "^default" | awk '{print $3}')
    echo
    echo "================NETWORK INFORMATION======="
    echo "IP Address      : $IP_ADDRESS"
    echo "Interface       : $INTERFACE"
    echo "Interface Status: $INTERFACE_STATUS"
    echo "Default Gateway : $DEFAULT_GATEWAY"
}

system_information
memory_information
cpu_information
disk_information
user_information
process_information
load_average
network_information



