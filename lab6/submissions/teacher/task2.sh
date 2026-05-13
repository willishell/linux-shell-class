#!/bin/bash

while IFS= read -r iface || [ -n "$iface" ]; do
    [ -z "$iface" ] && continue
    found=0
    while IFS= read -r addr; do
        [ -z "$addr" ] && continue
        echo "$iface $addr"
        found=1
    done < <(ip -o -4 address show dev "$iface" 2>/dev/null | awk '{print $4}')
    if [ "$found" -eq 0 ]; then
        echo "$iface NOTFOUND"
    fi
done
