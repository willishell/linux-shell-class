#!/bin/bash

PREFIX=$(cat)

# Regular mounts
mount | awk -v prefix="$PREFIX" '$1 ~ "^" prefix {print $1, $3}' | sort > /tmp/mounts_$$

# Swap
swapon -s | awk -v prefix="$PREFIX" 'NR>1 && $1 ~ "^" prefix {print $1, "[SWAP]"}' | sort >> /tmp/mounts_$$

cat /tmp/mounts_$$ | sort | uniq
rm /tmp/mounts_$$