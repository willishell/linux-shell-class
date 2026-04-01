#!/bin/bash
prefix=$(cat)
mount | awk -v p="$prefix" '$1 ~ "^"p {print $1}'
