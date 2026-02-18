#!/bin/bash

CACHE="/tmp/tmux_mem_usage.txt"
LOCK="/tmp/tmux_mem_usage.lock"

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

    # macOS: use vm_stat to calculate memory usage percentage
    PAGE_SIZE=$(sysctl -n hw.pagesize 2>/dev/null || echo 16384)
    TOTAL_MEM=$(sysctl -n hw.memsize 2>/dev/null)

    if [ -n "$TOTAL_MEM" ]; then
        VM_STAT=$(vm_stat 2>/dev/null)
        ACTIVE=$(echo "$VM_STAT" | awk '/Pages active/ {gsub(/\./, "", $NF); print $NF}')
        WIRED=$(echo "$VM_STAT" | awk '/Pages wired/ {gsub(/\./, "", $NF); print $NF}')
        COMPRESSED=$(echo "$VM_STAT" | awk '/Pages occupied by compressor/ {gsub(/\./, "", $NF); print $NF}')

        ACTIVE=${ACTIVE:-0}
        WIRED=${WIRED:-0}
        COMPRESSED=${COMPRESSED:-0}

        USED_BYTES=$(( (ACTIVE + WIRED + COMPRESSED) * PAGE_SIZE ))
        TOTAL_GB=$(awk "BEGIN { printf \"%.0f\", $TOTAL_MEM / 1073741824 }")
        USED_GB=$(awk "BEGIN { printf \"%.1f\", $USED_BYTES / 1073741824 }")
        PCT=$(awk "BEGIN { printf \"%.0f\", $USED_BYTES / $TOTAL_MEM * 100 }")

        echo "${USED_GB}/${TOTAL_GB}G(${PCT}%)" > "${CACHE}.tmp"
        mv "${CACHE}.tmp" "$CACHE"
    fi

    rm -f "$LOCK"
) >/dev/null 2>&1 &
