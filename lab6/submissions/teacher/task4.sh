#!/bin/bash

while IFS= read -r host || [ -n "$host" ]; do
    [ -z "$host" ] && continue
    addrs=$(getent hosts "$host" 2>/dev/null | awk '{print $1}' | awk '!seen[$0]++' | paste -sd, -)
    if [ -n "$addrs" ]; then
        echo "$host $addrs"
    else
        echo "$host NOTFOUND"
    fi
done
