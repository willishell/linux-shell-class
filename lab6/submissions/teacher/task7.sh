#!/bin/bash

while IFS= read -r url || [ -n "$url" ]; do
    [ -z "$url" ] && continue
    if ! command -v curl >/dev/null 2>&1; then
        echo "$url TOOL_MISSING"
        continue
    fi
    code=$(curl -L -s -o /dev/null --max-time 5 -w "%{http_code}" "$url" 2>/dev/null || true)
    [ -z "$code" ] && code="000"
    echo "$url $code"
done
