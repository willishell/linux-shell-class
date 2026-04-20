#!/bin/bash
set -euo pipefail

timezone=""
IFS= read -r timezone || [ -n "$timezone" ]

while IFS= read -r epoch || [ -n "$epoch" ]; do
    TZ="$timezone" date -d "@$epoch" '+%Y-%m-%d %H:%M:%S %Z'
done