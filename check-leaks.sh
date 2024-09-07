#!/usr/bin/env bash

set -eux

source passwords.sh
for p in ${PASSWORDS[@]}; do
    grep --exclude='passwords.sh' -r "$p" || true
    # grep --exclude='passwords.sh' -rl "$p" | xargs -r sed -i "s|$p|DATAEXPUNGED|g"
done
