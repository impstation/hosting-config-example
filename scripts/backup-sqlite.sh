#!/usr/bin/env bash
set -eux

dest="$HOME/backup"
run="$HOME/run"

server="$dest/server"
mkdir -p "$server"

# copy live to backup
filename='preferences.db'
source_file="$HOME/watchdog/instances/impstation/data/$filename"
dest_file="$server/$filename"
echo 'This might take a second - file size:'
ls -lh "$source_file"
rm "$dest_file"
# naive copy takes about 30s
# but can corrupt if running
# time cp "$source_file" "$dest_file"
# vacuum-based online backup takes about 2m
time sqlite3 "$source_file" "VACUUM INTO '$dest_file'"

# copy backup to snapshot
snapshots="$server/snapshots"
this_snapshot="$snapshots/$(date --iso-8601=seconds)"
mkdir -p "$this_snapshot"

filename_stripped='preferences-stripped.db'
stripped_file="$server/$filename_stripped"
snapshot_file="$this_snapshot/$filename_stripped"
time cp "$dest_file" "$stripped_file"

# strip snapshot
# removing logs takes file size from like 5GB to 3MB
# allowing us to take snapshots
time sqlite3 "$stripped_file" \
    'DELETE FROM admin_log; DELETE FROM admin_log_player;'
time sqlite3 "$stripped_file" 'VACUUM;'

cp "$stripped_file" "$snapshot_file"
# removing ip addresses preserves people's privacy
time sqlite3 "$snapshot_file" \
    "UPDATE connection_log SET address = ''; UPDATE player SET last_seen_address = '';"
time sqlite3 "$snapshot_file" 'VACUUM;'

echo 'Snapshot file size:'
ls -lh "$snapshot_file"
