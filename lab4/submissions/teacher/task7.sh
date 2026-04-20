#!/bin/bash
set -euo pipefail

crontab_file=""
username=""
IFS= read -r crontab_file || [ -n "$crontab_file" ]
IFS= read -r username || [ -n "$username" ]

awk -v user="$username" '
    NF == 0 || $1 ~ /^#/ {
        next
    }
    $6 == user {
        $1 = ""
        $2 = ""
        $3 = ""
        $4 = ""
        $5 = ""
        $6 = ""
        sub(/^[[:space:]]+/, "")
        print
    }
' "$crontab_file"