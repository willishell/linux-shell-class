#!/bin/bash
free -k | awk '/^Mem:/ {print $2}'
