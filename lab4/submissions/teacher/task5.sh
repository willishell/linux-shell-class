#!/bin/bash
set -euo pipefail

while IFS= read -r group_name || [ -n "$group_name" ]; do
    if record=$(awk -F: -v name="$group_name" '
        $1 == name {
            count = 0
            if ($4 != "") {
                count = split($4, members, ",")
            }
            print $1, $3, count
            found = 1
            exit
        }
        END {
            if (!found) {
                exit 1
            }
        }
    ' /etc/group); then
        echo "$record"
    else
        echo "$group_name NOTFOUND"
    fi
done