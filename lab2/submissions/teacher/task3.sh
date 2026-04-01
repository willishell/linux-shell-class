#!/bin/bash
while read dev; do
    size_file="/sys/block/$dev/size"
    [ -f "$size_file" ] && echo "$dev $(cat $size_file)"
done
