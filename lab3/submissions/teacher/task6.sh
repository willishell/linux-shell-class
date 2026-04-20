#!/bin/bash

FILE=$(cat)
grep -v '^#' "$FILE" | awk '{print $2}' | grep -v '^$'