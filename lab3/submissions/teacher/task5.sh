#!/bin/bash

free -b | awk 'NR==3 {print $2, $3}'
