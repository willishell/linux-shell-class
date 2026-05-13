#!/bin/bash
while IFS= read -r lib || [ -n "$lib" ]; do
    if [ -z "$lib" ]; then continue; fi
    if lsof -p $$ 2>/dev/null | grep -F -q "$lib"; then
        echo "$lib yes"
    else
        echo "$lib no"
    fi
done
