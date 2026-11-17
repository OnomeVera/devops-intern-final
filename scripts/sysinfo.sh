
#!/usr/bin/env bash

set -euo pipefail

echo "======================================"
echo "       SYSTEM INFORMATION REPORT"
echo "======================================"

echo ""
echo "Current User:"
id -un

echo ""
echo "Effective UID:"
id -u

echo ""
echo "Hostname:"
hostname

echo ""
echo "Kernel Release:"
uname -r

echo ""
echo "System Date (ISO-8601):"
date '+%Y-%m-%dT%H:%M:%S%:z'

echo ""
echo "Disk Usage:"
df -h

echo ""
echo "Memory Usage:"

if [[ -r /proc/meminfo ]]; then
    awk '
    /MemTotal:/ { total=$2 }
    /MemAvailable:/ { available=$2 }
    END {
        used=total-available
        printf "Total: %.2f GiB\n", total/1048576
        printf "Used: %.2f GiB\n", used/1048576
        printf "Available: %.2f GiB\n", available/1048576
    }' /proc/meminfo
else
    echo "Memory information unavailable."
fi

echo ""
echo "Docker Daemon Status:"

if command -v docker >/dev/null 2>&1; then
    if docker info >/dev/null 2>&1; then
        echo "Docker daemon is RUNNING."
    else
        echo "Docker daemon is NOT RUNNING or inaccessible."
    fi
else
    echo "Docker CLI is NOT INSTALLED."
fi

echo ""
echo "======================================"
echo "       SYSTEM REPORT COMPLETED"
echo "======================================"
