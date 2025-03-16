#!/usr/bin/env bash

set -eux

DELETE_OLDER_THAN_DAYS=10

find '/opt/SS14.Watchdog/instances/impstation/data/www/replays/' \
    -mindepth 1 \
    -type f \
    -mtime "+$DELETE_OLDER_THAN_DAYS" \
    -delete -print
