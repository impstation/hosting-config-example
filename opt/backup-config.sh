#!/usr/bin/env bash
set -eux

# opt this then do:
# etckeeper commit "whatever"
# to back up all configs

etc='/etc/ss14'
opt='/opt'

cp -t "$etc" \
    "$HOME/README.md" \
    "$HOME/backup-config.sh" \
    "$HOME/backup-postgres.sh" \
    "$HOME/backup-sqlite.sh" \
    "$HOME/cdn-update.sh" \
    "$HOME/make-config-symlinks.sh" \
    "$HOME/vacuum-replays.sh" \
    "$HOME/watchdog-update.sh"

# all replaced with symlinks method!

# cdn='Robust.Cdn'
# mkdir -p "$etc/$cdn"
# cp "$opt/$cdn/appsettings.json" "$etc/$cdn"
# cp "$opt/$cdn/appsettings.Development.json" "$etc/$cdn"

# admin='SS14.Admin'
# mkdir -p "$etc/$admin"
# cp "$opt/$admin/appsettings.yml" "$etc/$admin"

# changelog='SS14.Changelog'
# mkdir -p "$etc/$changelog"
# cp "$opt/$changelog/appsettings.yml" "$etc/$changelog"

# watchdog='SS14.Watchdog'
# mkdir -p "$etc/$watchdog"
# cp "$opt/$watchdog/appsettings.yml" "$etc/$watchdog"

# server='impstation'
# mkdir -p "$etc/$server"
# cp "$opt/$watchdog/instances/$server/config.toml" "$etc/$server"

# server_staging='impstation-staging'
# mkdir -p "$etc/$server_staging"
# cp "$opt/$watchdog/instances/$server_staging/config.toml" "$etc/$server_staging"
