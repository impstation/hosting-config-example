#!/usr/bin/env bash

set -eux

dest="/root/backup/postgres"
mkdir -p "$dest"
snapshot="$dest/$(date --iso-8601=seconds).dump"

pg_dump \
    --username='postgres' \
    --host='localhost' \
    --format='custom' \
    --exclude-table-data 'admin_log' \
    --exclude-table-data 'admin_log_player' \
    'impstation' \
    > "$snapshot"

ls -lh "$snapshot"
