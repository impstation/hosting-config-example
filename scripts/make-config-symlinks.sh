#!/usr/bin/env bash
set -eux

etc='/etc/ss14'
opt='/opt'

cdn='Robust.Cdn'
ln -s -f -t "$opt/$cdn" "$etc/$cdn/appsettings.json"

admin='SS14.Admin'
ln -s -f -t "$opt/$admin" "$etc/$admin/appsettings.yml"

changelog='SS14.Changelog'
ln -s -f -t "$opt/$changelog" "$etc/$changelog/appsettings.yml"

watchdog='SS14.Watchdog'
ln -s -f -t "$opt/$watchdog" "$etc/$watchdog/appsettings.yml"

server='impstation'
ln -s -f -t "$opt/$watchdog/instances/$server" "$etc/$server/config.toml"

server_staging='impstation-staging'
ln -s -f -t "$opt/$watchdog/instances/$server_staging" "$etc/$server_staging/config.toml"
