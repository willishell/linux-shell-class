#!/bin/bash

while read -r service proto extra || [ -n "${service:-}" ]; do
    [ -z "${service:-}" ] && continue
    port=$(awk -v svc="$service" -v proto="$proto" '
        $0 !~ /^[[:space:]]*#/ && $1 == svc {
            split($2, p, "/")
            if (p[2] == proto) {
                print p[1]
                exit
            }
        }
    ' /etc/services)
    if [ -n "$port" ]; then
        echo "$service/$proto $port"
    else
        echo "$service/$proto NOTFOUND"
    fi
done
