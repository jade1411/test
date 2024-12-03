#!/bin/bash

LOG_FILE="/var/log/monitoring.log"
PROCESS_NAME="test"
API_URL="https://test.com/monitoring/test/api"

if pgrep -x "$PROCESS_NAME" > /dev/null; then
    if [ -f "/tmp/${PROCESS_NAME}_running" ]; then
        curl -s -o /dev/null -w "%{http_code}" "$API_URL"
        if [ $? -ne 0 ]; then
            echo "$(date): Could not connect to $API_URL" >> "$LOG_FILE"
        fi
    else
        touch "/tmp/${PROCESS_NAME}_running"
        
        curl -s -o /dev/null -w "%{http_code}" "$API_URL"
        if [ $? -ne 0 ]; then
            echo "$(date): Could not connect to $API_URL" >> "$LOG_FILE"
        fi
    fi
else
    if [ -f "/tmp/${PROCESS_NAME}_running" ]; then
        rm "/tmp/${PROCESS_NAME}_running"
    fi
fi
