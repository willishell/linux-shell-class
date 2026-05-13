#!/bin/bash

int_to_ip() {
    local n=$1
    printf "%d.%d.%d.%d" \
        $(((n >> 24) & 255)) \
        $(((n >> 16) & 255)) \
        $(((n >> 8) & 255)) \
        $((n & 255))
}

while IFS= read -r cidr || [ -n "$cidr" ]; do
    [ -z "$cidr" ] && continue
    ip=${cidr%/*}
    prefix=${cidr#*/}
    IFS=. read -r a b c d <<< "$ip"

    ip_int=$(( (a << 24) + (b << 16) + (c << 8) + d ))
    mask=$(( (0xFFFFFFFF << (32 - prefix)) & 0xFFFFFFFF ))
    network=$(( ip_int & mask ))
    broadcast=$(( network | (0xFFFFFFFF ^ mask) ))
    first=$(( network + 1 ))
    last=$(( broadcast - 1 ))
    usable=$(( (1 << (32 - prefix)) - 2 ))

    printf "%s %s %s %s %s %d\n" \
        "$cidr" \
        "$(int_to_ip "$network")" \
        "$(int_to_ip "$mask")" \
        "$(int_to_ip "$first")" \
        "$(int_to_ip "$last")" \
        "$usable"
done
