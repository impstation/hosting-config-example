#!/usr/bin/env bash

set -eux

dest="/root/backup/admin_logs_postgres"
mkdir -p "$dest"
snapshot_name="$(date --iso-8601=seconds)"
snapshot="$dest/${snapshot_name}"

# custom format is more convenient for tiny snapshots
# cause you get a single file
# directory format is more convenient for full dump
# cause you can use parallel outputs with --jobs
# jobs just has to be over 2 cause only the two log tables
# take longer than a few seconds to dump
# 19 is max compression for zstd
# last dump Nov 25 took around five hours
# and dumped multiple tens of gigabytes of logs into 1.5G
pg_dump \
    --username='postgres' \
    --host='localhost' \
    --verbose \
    --format='directory' \
    --file="$snapshot" \
    --jobs='4' \
    --compress='zstd:19' \
    'impstation'
