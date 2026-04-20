#!/bin/bash
set -euo pipefail

while IFS= read -r component || [ -n "$component" ]; do
    case "$component" in
        journald)
            if journalctl -n 1 --no-pager >/dev/null 2>&1; then
                echo "journald yes"
            else
                echo "journald no"
            fi
            ;;
        rsyslog)
            if [ -f /etc/rsyslog.conf ]; then
                echo "rsyslog yes"
            else
                echo "rsyslog no"
            fi
            ;;
        syslog-ng)
            if [ -d /etc/syslog-ng ]; then
                echo "syslog-ng yes"
            else
                echo "syslog-ng no"
            fi
            ;;
    esac
done