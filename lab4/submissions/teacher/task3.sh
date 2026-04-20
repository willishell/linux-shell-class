#!/bin/bash
set -euo pipefail

while IFS= read -r username || [ -n "$username" ]; do
    if record=$(awk -F: -v name="$username" '
        $1 == name {
            print $1, $3, $4, $6, $7
            found = 1
            exit
        }
        END {
            if (!found) {
                exit 1
            }
        }
    ' /etc/passwd); then
        echo "$record"
    else
        echo "$username NOTFOUND"
    fi
done