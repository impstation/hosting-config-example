#!/usr/bin/env bash
set -eux

# run this then do:
# etckeeper commit "whatever"
# to back up all configs

dest='/etc/ss14'
run='/opt'

cp -t "$dest" \
    "$HOME/README.md" \
    "$HOME/backup-config.sh" \
    "$HOME/backup-postgres.sh" \
    "$HOME/backup-sqlite.sh" \
    "$HOME/cdn-update.sh" \
    "$HOME/vacuum-replays.sh" \
    "$HOME/watchdog-update.sh"

cdn='Robust.Cdn'
mkdir -p "$dest/$cdn"
cp "$run/$cdn/appsettings.json" "$dest/$cdn"
cp "$run/$cdn/appsettings.Development.json" "$dest/$cdn"

admin='SS14.Admin'
mkdir -p "$dest/$admin"
cp "$run/$admin/appsettings.yml" "$dest/$admin"

changelog='SS14.Changelog'
mkdir -p "$dest/$changelog"
cp "$run/$changelog/appsettings.yml" "$dest/$changelog"

watchdog='SS14.Watchdog'
mkdir -p "$dest/$watchdog"
cp "$run/$watchdog/appsettings.yml" "$dest/$watchdog"

server='impstation'
mkdir -p "$dest/$server"
cp "$run/$watchdog/instances/$server/config.toml" "$dest/$server"

server_staging='impstation-staging'
mkdir -p "$dest/$server_staging"
# cp "$run/$watchdog/instances/$server_staging/config.toml" "$dest/$server_staging"
