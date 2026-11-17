#!/usr/bin/env bash

set -euo pipefail

TARGET_URL="${1:-http://localhost:8080}"

echo "======================================"
echo "       APPLICATION HEALTH CHECK"
echo "======================================"

echo "Target: ${TARGET_URL}"

if ! command -v curl >/dev/null 2>&1; then
    echo "ERROR: curl is not installed."
    exit 1
fi

HTTP_STATUS=$(curl \
    --silent \
    --output /dev/null \
    --write-out "%{http_code}" \
    --connect-timeout 5 \
    --max-time 10 \
    "$TARGET_URL") || {
        echo "ERROR: Unable to connect to ${TARGET_URL}"
        exit 1
    }

if [[ "$HTTP_STATUS" == "200" ]]; then
    echo "SUCCESS: Application is healthy."
    echo "HTTP Status: ${HTTP_STATUS}"
    exit 0
else
    echo "ERROR: Application returned HTTP ${HTTP_STATUS}"
    exit 1
fi
