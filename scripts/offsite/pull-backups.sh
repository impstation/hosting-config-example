#!/usr/bin/env bash

set -eux

rsync \
    --verbose \
    --archive \
    --recursive \
    --remove-source-files \
    -e 'ssh -p 56557' \
    'backup_egress@impstation.gay:dropoff/*' \
    "${HOME}/pickup/"
