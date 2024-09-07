#!/usr/bin/env bash
set -eux

etc='/etc/ss14'
opt='/opt'

# you can run this once to copy config files from the builds directories in /opt
# to the versioned location in /etc, then run make-config-symlinks.sh

cdn='Robust.Cdn'
mkdir -p "$etc/$cdn"
cp "$opt/$cdn/appsettings.json" "$etc/$cdn"
cp "$opt/$cdn/appsettings.Development.json" "$etc/$cdn"

admin='SS14.Admin'
mkdir -p "$etc/$admin"
cp "$opt/$admin/appsettings.yml" "$etc/$admin"

changelog='SS14.Changelog'
mkdir -p "$etc/$changelog"
cp "$opt/$changelog/appsettings.yml" "$etc/$changelog"

watchdog='SS14.Watchdog'
mkdir -p "$etc/$watchdog"
cp "$opt/$watchdog/appsettings.yml" "$etc/$watchdog"

server='impstation'
mkdir -p "$etc/$server"
cp "$opt/$watchdog/instances/$server/config.toml" "$etc/$server"

server_staging='impstation-staging'
mkdir -p "$etc/$server_staging"
cp "$opt/$watchdog/instances/$server_staging/config.toml" "$etc/$server_staging"
