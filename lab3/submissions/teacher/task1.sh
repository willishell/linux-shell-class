#!/bin/bash

DISK=$(cat)
lsblk -ln -o NAME "$DISK" | grep "^${DISK##*/}[0-9]" | sort