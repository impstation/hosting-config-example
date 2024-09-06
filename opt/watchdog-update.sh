#!/usr/bin/env bash

set -eux

curl \
    -v \
    -X 'POST' \
    -u 'impstation:DATAEXPUNGED' \
    'http://localhost:5000/instances/impstation/update'
