#!/bin/bash

while IFS= read -r dest || [ -n "$dest" ]; do
    [ -z "$dest" ] && continue
    route=$(ip route get "$dest" 2>/dev/null | head -n 1 || true)
    if [ -z "$route" ]; then
        echo "$dest UNREACHABLE"
        continue
    fi

    dev=$(awk '{for (i=1;i<=NF;i++) if ($i=="dev") {print $(i+1); exit}}' <<< "$route")
    src=$(awk '{for (i=1;i<=NF;i++) if ($i=="src") {print $(i+1); exit}}' <<< "$route")
    via=$(awk '{for (i=1;i<=NF;i++) if ($i=="via") {print $(i+1); exit}}' <<< "$route")

    [ -z "$dev" ] && dev="NONE"
    [ -z "$src" ] && src="NONE"
    [ -z "$via" ] && via="DIRECT"
    echo "$dest dev=$dev src=$src via=$via"
done
