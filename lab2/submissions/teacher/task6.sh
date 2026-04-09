#!/bin/bash
read infile outfile
dd if="$infile" of="$outfile" bs=5 skip=1 count=2 status=none
cat "$outfile"
