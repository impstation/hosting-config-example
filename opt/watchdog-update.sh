#!/usr/bin/env bash

set -eux

curl \
    -v \
    -X 'POST' \
    -u 'impstation:REDACTED0' \
    'http://localhost:5000/instances/impstation/update'
