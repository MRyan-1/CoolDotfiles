#!/bin/bash

CACHE="/tmp/tmux_cpu_usage.txt"
LOCK="/tmp/tmux_cpu_usage.lock"

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
    
    VAL=$(iostat -c 2 | tail -n 1 | awk '{printf "%.1f", 100 - $6}')
    
    if [ -n "$VAL" ]; then
        echo "${VAL}%" > "${CACHE}.tmp"
        mv "${CACHE}.tmp" "$CACHE"
    fi
    
    rm -f "$LOCK"
) >/dev/null 2>&1 &
