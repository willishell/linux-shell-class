#!/bin/bash

free | awk 'NR==3 {print $2, $3}'