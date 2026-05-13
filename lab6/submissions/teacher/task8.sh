#!/bin/bash

config_files=()
[ -r /etc/ssh/sshd_config ] && config_files+=(/etc/ssh/sshd_config)
for f in /etc/ssh/sshd_config.d/*.conf; do
    [ -r "$f" ] && config_files+=("$f")
done

while IFS= read -r key || [ -n "$key" ]; do
    [ -z "$key" ] && continue
    value=""
    if [ "${#config_files[@]}" -gt 0 ]; then
        value=$(awk -v wanted="$key" '
            BEGIN { wanted=tolower(wanted) }
            /^[[:space:]]*($|#)/ { next }
            {
                name=tolower($1)
                if (name == wanted) {
                    $1=""
                    sub(/^[[:space:]]+/, "")
                    val=$0
                }
            }
            END { if (val != "") print val }
        ' "${config_files[@]}")
    fi

    if [ -n "$value" ]; then
        echo "$key $value"
    else
        echo "$key NOTFOUND"
    fi
done
