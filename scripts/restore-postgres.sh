#!/usr/bin/env bash

set -eux

source="/root/backup/postgres"

snapshot_name='2025-01-15T21:26:51+00:00.dump'
snapshot="$source/$snapshot_name"

# careful replacing dbname
# the --no-owner argument lets us restore to another user for testing
pg_restore \
    --username='impstation_staging' \
    --host='localhost' \
    --dbname 'impstation_staging' \
    --clean \
    --no-owner \
    "$snapshot"
