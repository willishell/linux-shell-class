#!/bin/bash
while IFS= read -r cmd || [ -n "$cmd" ]; do
    if [ -z "$cmd" ]; then continue; fi
    user=$(ps -C "$cmd" -o user= --sort=pid 2>/dev/null | head -n 1 | tr -d ' ' || true)
    if [ -n "$user" ]; then
        echo "$cmd $user"
    else
        echo "$cmd NOTFOUND"
    fi
done
