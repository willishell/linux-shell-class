#!/bin/bash
outfile=$(cat)
dd if=/dev/zero of="$outfile" bs=1K count=1 status=none
echo "OK"
