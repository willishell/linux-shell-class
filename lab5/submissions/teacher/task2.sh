#!/bin/bash
while IFS= read -r cmd || [ -n "$cmd" ]; do
    if [ -z "$cmd" ]; then continue; fi
    ni=$(ps -C "$cmd" -o ni= --sort=pid | head -n 1 | tr -d ' ' || true)
    if [ -n "$ni" ]; then
        echo "$cmd $ni"
    else
        echo "$cmd NOTFOUND"
    fi
done
