#!/usr/bin/env bash

set -eux

# WATCHDOG_TOKEN=''

curl \
    -v \
    -X 'POST' \
    -u "impstation:${WATCHDOG_TOKEN}" \
    'http://localhost:5000/instances/impstation/update'
