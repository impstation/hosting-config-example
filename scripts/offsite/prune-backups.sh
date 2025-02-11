#!/usr/bin/env bash

set -eux

DELETE_OLDER_THAN_DAYS=10

find "${HOME}/pickup/" \
    -mindepth 1 \
    -type f \
    -mtime "+$DELETE_OLDER_THAN_DAYS" \
    -delete -print
