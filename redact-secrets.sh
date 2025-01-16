#!/usr/bin/env bash

set -eu

source passwords.sh
for i in ${!PASSWORDS[@]}; do
    p="${PASSWORDS[i]}"
    # grep --exclude='passwords.sh' -r "$p" || true
    grep --exclude='passwords.sh' -rl "$p" | xargs -r sed -i "s|$p|REDACTED$i|g"
done
