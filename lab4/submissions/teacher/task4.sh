#!/bin/bash
set -euo pipefail

while IFS= read -r username || [ -n "$username" ]; do
    if shell=$(awk -F: -v name="$username" '
        $1 == name {
            print $7
            found = 1
            exit
        }
        END {
            if (!found) {
                exit 1
            }
        }
    ' /etc/passwd); then
        if [ "$shell" = "/bin/false" ] || [[ "$shell" == *nologin* ]]; then
            echo "$username no-login"
        else
            echo "$username login"
        fi
    else
        echo "$username NOTFOUND"
    fi
done