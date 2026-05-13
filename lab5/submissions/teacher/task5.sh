#!/bin/bash
while IFS= read -r cmd || [ -n "$cmd" ]; do
    if [ -z "$cmd" ]; then continue; fi
    pid=$(ps -C "$cmd" -o pid= --sort=pid | head -n 1 | tr -d ' ')
    if [ -z "$pid" ]; then
        echo "$cmd NOTFOUND"
    else
        tc=$(ps -o thcount= -p "$pid" | tr -d ' ' || true)
        if [ -n "$tc" ] && [ "$tc" -gt 1 ]; then
            echo "$cmd multithreaded"
        else
            echo "$cmd single-threaded"
        fi
    fi
done
