#!/bin/bash
lsof -p $$ -a -d cwd -F n
