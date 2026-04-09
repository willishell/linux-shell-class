#!/bin/bash
while read dev; do
    udevadm info --query=property --name="$dev" 2>/dev/null |     grep -E "DEVNAME=|DEVTYPE=" |     awk -F= '
        /DEVNAME/ {name=$2}
        /DEVTYPE/ {type=$2}
        END {if(name && type) print name, type}
   '
done
