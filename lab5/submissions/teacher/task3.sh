#!/bin/bash
while IFS= read -r fname || [ -n "$fname" ]; do
    if [ -z "$fname" ]; then continue; fi
    err=$(strace -e openat cat "$fname" 2>&1 | grep -F "$fname" | grep -o "ENOENT" | head -n 1 || true)
    if [ -n "$err" ]; then
        echo "$fname $err"
    else
        echo "$fname NO_ENOENT"
    fi
done
