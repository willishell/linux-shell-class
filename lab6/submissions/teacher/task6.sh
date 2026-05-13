#!/bin/bash

port_is_listening() {
    local proto=$1
    local port=$2
    local opt
    case "$proto" in
        tcp) opt="-ltnH" ;;
        udp) opt="-lunH" ;;
        *) return 1 ;;
    esac
    ss $opt 2>/dev/null | awk -v port="$port" '
        {
            local=$4
            sub(/%[^]]+/, "", local)
            if (local ~ ("[:.]" port "$")) found=1
        }
        END { exit found ? 0 : 1 }
    '
}

while read -r proto port extra || [ -n "${proto:-}" ]; do
    [ -z "${proto:-}" ] && continue
    if port_is_listening "$proto" "$port"; then
        echo "$proto/$port yes"
    else
        echo "$proto/$port no"
    fi
done
