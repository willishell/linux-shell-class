#!/bin/bash
while IFS= read -r dev || [ -n "$dev" ]; do
    dev=${dev//$'\r'/}
    [ -e "$dev" ] || continue
    type=$(stat -c "%F" "$dev")
    name=$(basename "$dev")
    case "$type" in
        *block*) echo "b $name" ;;
        *character*) echo "c $name" ;;
    esac
done
