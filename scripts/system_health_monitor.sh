#!/bin/bash
LOG_DIR="logs"
LOG_FILE="$LOG_DIR/Linux_System_Health_Monitor.log"

mkdir -p "$LOG_DIR"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log() {
     echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

CONFIG_FILE="config/settings.conf"

if [ -f "$CONFIG_FILE" ]
then
    source "$CONFIG_FILE"
else
    echo "ERROR: Configuration file not found."
    exit 1
fi

exec > >(tee -a "$LOG_FILE") 2>&1
log "Script started"

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

check_command() {
    command -v "$1" >/dev/null 2>&1 || {
    echo "ERROR : Required command '$1' is not installed."
    exit 1
  }
}

help_menu() {
    echo
    echo "Linux System Health Monitor"
    echo
    echo "Usage:"
    echo "./scripts/system_health_monitor.sh --all"
    echo "     Display complete system report"
    echo
    echo "./scripts/system_health_monitor.sh --system"
    echo "     Display system information"
    echo
    echo "./scripts/system_health_monitor.sh --memory"
    echo "     Display memory information"
    echo
    echo "./scripts/system_health_monitor.sh --cpu"
    echo "     Display CPU information"
    echo
    echo "./scripts/system_health_monitor.sh --disk"
    echo "     Display disk information"
    echo
    echo "./scripts/system_health_monitor.sh --user"
    echo "     Display current user information"
    echo
    echo "./scripts/system_health_monitor.sh --process"
    echo "     Display running processes"
    echo
    echo "./scripts/system_health_monitor.sh --load"
    echo "     Display system load average"
    echo
    echo "./scripts/system_health_monitor.sh --network"
    echo "     Display network information"
    echo
    echo "./scripts/system_health_monitor.sh --help"
    echo "     Show this help message"
    echo
}
 
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
    MEMORY_USAGE=$(free | awk 'NR==2 {printf "%.0f", $3/$2 * 100}')
    echo
    echo "=========MEMORY INFORMATION========="
    echo "TOTAL MEMORY     : $TOTAL_MEMORY"
    echo "USED MEMORY      : $USED_MEMORY"
    echo "FREE MEMORY      : $FREE_MEMORY"
    echo "AVAILABLE MEMORY : $AVAILABLE_MEMORY"
    echo
    echo "=========MEMORY HEALTH=============="
    echo "Memory Threshold : ${MEMORY_THRESHOLD}%"
    echo "Memory Usage : ${MEMORY_USAGE}%"
    
    if [ "$MEMORY_USAGE" -gt "$MEMORY_THRESHOLD" ]
    then
        echo -e "Memory Status : ${RED}WARNING${NC}"
    else
        echo -e "Memory Status : ${GREEN}NORMAL${NC}"
    fi
    echo
}
# Displays CPU information.
cpu_information(){
    CPU_ARCHITECTURE=$(lscpu | grep "Architecture" | awk '{print $2}')
    CPU_COUNT=$(lscpu | grep "^CPU(s): " | awk '{print $2}')
    CPU_MODEL=$(lscpu | grep "Model name" | cut -d':' -f2 | xargs)

   CPU_USAGE=$(top -bn1 | awk -F'id,' '/Cpu/ {split($1,a,","); split(a[4],b," "); printf "%.0f",100-b[length(b)]}')
    echo
    echo "=============CPU INFORMATION=========="
    echo "Architecture : $CPU_ARCHITECTURE"
    echo "CPU Count : $CPU_COUNT"
    echo "CPU Model : $CPU_MODEL"
    echo "CPU Usage : ${CPU_USAGE}%"
    
    if [ "$CPU_USAGE" -gt "$CPU_THRESHOLD" ]
    then
        echo -e "CPU Status : ${RED}HIGH CPU USAGE${NC}"
    else
        echo -e "CPU Status : ${GREEN}NORMAL${NC}"
    fi
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
    if [ "$DISK_USAGE_NUM" -gt "$DISK_THRESHOLD" ] 
    then
        echo -e "DISK Status : ${RED}WARNING${NC}"
    else
        echo -e "DISK Status : ${GREEN}HEALTHY${NC}"
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
    
    echo
    echo "======================RUNNING PROCESSES================="
    echo "Total Running Processes : $TOTAL_PROCESSES"
    echo 
    echo "Top 5 Processes:"
    ps -eo pid,user,%cpu,%mem,comm --sort=-%cpu | head -6

    echo

    if [ "$TOTAL_PROCESSES" -gt "$PROCESS_THRESHOLD" ]
    then
        echo -e "Process Status : ${RED}HIGH PROCESS COUNT${NC}"
    else
        echo -e "Process Status : ${GREEN}NORMAL${NC}"
    fi

    echo
}
# Displays load average.
load_average(){
    LOAD_AVERAGE=$(uptime | awk -F'load average: ' '{print $2}')
    LOAD_1=$(echo "$LOAD_AVERAGE" | cut -d',' -f1)
    CPU_COUNT=$(nproc)
    echo
    echo "================LOAD AVERAGE==============="
    echo "Load Average : $LOAD_AVERAGE"
    
    if (( $(echo "$LOAD_1 > $CPU_COUNT" | bc -l) ))
    then
        echo -e "Load Status : ${RED}HIGH LOAD${NC}"
    else
        echo -e "Load Status : ${GREEN}NORMAL${NC}"
    fi

    echo
}
# Displays network information.
network_information(){
    IP_ADDRESS=$(hostname -I)
    INTERFACE=$(ip -br addr | grep "eth0" | awk '{print $1}')
    INTERFACE_STATUS=$(ip -br addr | grep "eth0" | awk '{print $2}')
    DEFAULT_GATEWAY=$(ip route | grep "^default" | awk '{print $3}')
    echo
    echo "================NETWORK INFORMATION============="
    echo "IP Address      : $IP_ADDRESS"
    echo "Interface       : $INTERFACE"
    echo "Interface Status: $INTERFACE_STATUS"
    echo "Default Gateway : $DEFAULT_GATEWAY"
    echo
    if [ "$INTERFACE_STATUS" = "UP" ]
    then
        echo -e "Network Status : ${GREEN}CONNECTED${NC}"
    else
        echo -e "Network Status : ${RED}DISCONNECTED${NC}"
    fi

    echo
}

for cmd in hostname date uptime free lscpu df whoami id ps awk grep cut xargs ip top bc
do
    check_command "$cmd"
done


case "$1" in
    --system)
      system_information
      ;;
    --memory)
      memory_information
      ;;
    --cpu)
      cpu_information
      ;;
    --disk)
      disk_information
      ;;
    --user)
      user_information
      ;;
    --process)
      process_information
      ;;
    --load)
      load_average
      ;;
    --network)
      network_information
      ;;
    --help)
      help_menu
      ;;
    --all|"")
     system_information
     memory_information
     cpu_information
     disk_information
     user_information
     process_information
     load_average
     network_information
     ;;
    *)
      help_menu
     ;;
esac
