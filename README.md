# Linux System Health Monitor

A Bash scripting project that monitors the overall health of a Linux system by collecting important system information such as CPU usage, memory usage, disk usage, system uptime, running processes, load average, user information, and network details.

## Features

- System Information
- Memory Monitoring
- CPU Monitoring
- Disk Usage Monitoring
- User Information
- Running Processes
- Load Average Monitoring
- Network Information
- Health Status Checks
- Configuration File Support
- Logging Support
- Command-Line Arguments

## Project Structure

```
Linux_System_Health_Monitor/
├── README.md
├── config/
│   └── settings.conf
├── docs/
├── logs/
│   └── Linux_System_Health_Monitor.log
├── reports/
└── scripts/
    └── system_health_monitor.sh
```

## Usage

Run complete report:

```bash
./scripts/system_health_monitor.sh --all
```

Run individual modules:

```bash
./scripts/system_health_monitor.sh --system
./scripts/system_health_monitor.sh --memory
./scripts/system_health_monitor.sh --cpu
./scripts/system_health_monitor.sh --disk
./scripts/system_health_monitor.sh --user
./scripts/system_health_monitor.sh --process
./scripts/system_health_monitor.sh --load
./scripts/system_health_monitor.sh --network
./scripts/system_health_monitor.sh --help
```

## Technologies Used

- Bash Shell Scripting
- Linux Commands
- AWK
- GREP
- CUT
- TOP
- FREE
- DF
- PS
- BC
- Git
- GitHub

## Skills Demonstrated

- Bash Scripting
- Linux Administration
- Shell Functions
- Configuration Management
- Log Management
- Process Monitoring
- System Monitoring
- Git Version Control

## Author

**Chaitrali Supali**
