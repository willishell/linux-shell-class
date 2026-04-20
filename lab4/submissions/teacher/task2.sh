#!/bin/bash
set -euo pipefail

prefix=""
IFS= read -r prefix || [ -n "$prefix" ]

journalctl -F _SYSTEMD_UNIT 2>/dev/null | grep -F "$prefix" | sort -u || true