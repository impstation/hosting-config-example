#!/usr/bin/env bash

set -eux

source passwords.sh
for p in ${PASSWORDS[@]}; do
    grep -r "$p"
    # grep -rl "$p" | xargs sed -i "s/$p/DATAEXPUNGED/g"
done
