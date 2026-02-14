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

    VAL=""
    if [ -x "$MACMON" ] && [ -x "$JQ" ]; then
        RAW=$($MACMON pipe -i 100 2>/dev/null | head -n 1)
        if [ -n "$RAW" ]; then
            VAL=$(printf '%s' "$RAW" | $JQ -r '
                .gpu_usage[1] // 0 | . * 100 | floor
            ' 2>/dev/null)
        fi
    fi

    if [ -n "$VAL" ] && [ "$VAL" != "null" ]; then
        echo "${VAL}%" > "${CACHE}.tmp"
        mv "${CACHE}.tmp" "$CACHE"
    elif [ ! -f "$CACHE" ]; then
        echo "N/A" > "$CACHE"
    fi

    rm -f "$LOCK"
) >/dev/null 2>&1 &
