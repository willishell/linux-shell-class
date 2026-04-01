#!/bin/bash
while read dev; do
    [ -e "$dev" ] || continue
    type=$(stat -c "%F" "$dev")
    name=$(basename "$dev")
    case "$type" in
        *block*) echo "b $name" ;;
        *character*) echo "c $name" ;;
    esac
done
