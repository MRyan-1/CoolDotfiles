#!/bin/bash

CACHE="/tmp/tmux_gpu_usage.txt"
LOCK="/tmp/tmux_gpu_usage.lock"
MACMON="/opt/homebrew/bin/macmon"
JQ="/opt/homebrew/bin/jq"

if [ -f "$CACHE" ]; then
    cat "$CACHE"
else
    echo "..."
fi

(
    NOW=$(date +%s)
    if [ -f "$LOCK" ]; then
        MTIME=$(stat -f %m "$LOCK")
        AGE=$((NOW - MTIME))
        if [ "$AGE" -lt 15 ]; then
            exit 0
        fi
    fi
    
    touch "$LOCK"
    
    VAL=$($MACMON pipe -i 100 2>/dev/null | head -n 1 | $JQ -r '.gpu_usage[1] * 100 | floor' 2>/dev/null)
    
    if [ -n "$VAL" ]; then
        echo "$VAL" > "${CACHE}.tmp"
        mv "${CACHE}.tmp" "$CACHE"
    fi
    
    rm -f "$LOCK"
) >/dev/null 2>&1 &
