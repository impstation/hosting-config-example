#!/usr/bin/env bash

set -eux

dest="/root/backup/postgres"
mkdir -p "$dest"
snapshot_name="$(date --iso-8601=seconds).dump"
snapshot="$dest/${snapshot_name}"

# offsite backup dropoff
egress_user='backup_egress'
outbox="/home/${egress_user}/dropoff"
mkdir -p "${outbox}"
chown "${egress_user}:${egress_user}" "${outbox}"

pg_dump \
    --username='postgres' \
    --host='localhost' \
    --verbose \
    --format='custom' \
    --file="$snapshot" \
    --exclude-table-data='admin_log' \
    --exclude-table-data='admin_log_player' \
    'impstation'

ls -lh "$snapshot"

snapshot_egress="${outbox}/${snapshot_name}"
cp "${snapshot}" "${snapshot_egress}"
chown "${egress_user}:${egress_user}" "${snapshot_egress}"
