#!/bin/bash

df -h --output=source,size | awk 'NR>1 && $1 ~ /^\/dev/ {print $1, $2}' | sort
