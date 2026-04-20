#!/bin/bash

FILE=$(cat)
grep -c "processor" "$FILE"