#!/bin/bash

DEVICES=$(cat)
lsblk -ln -o NAME,FSTYPE $DEVICES | awk '{print $1, $2}'