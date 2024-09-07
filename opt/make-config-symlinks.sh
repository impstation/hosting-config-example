#!/usr/bin/env bash
set -eux

etc='/etc/ss14'
opt='/opt'

cdn='Robust.Cdn'
ln -s -f "$etc/$cdn/appsettings.json" "$opt/$cdn" 
ln -s -f "$etc/$cdn/appsettings.Development.json" "$opt/$cdn"

admin='SS14.Admin'
ln -s -f "$etc/$admin/appsettings.yml" "$opt/$admin"

changelog='SS14.Changelog'
ln -s -f "$etc/$changelog/appsettings.yml" "$opt/$changelog" 

watchdog='SS14.Watchdog'
ln -s -f "$etc/$watchdog/appsettings.yml" "$opt/$watchdog" 

server='impstation'
ln -s -f "$etc/$server/config.toml" "$opt/$watchdog/instances/$server" 

# server_staging='impstation-staging'
# ln -s -f "$etc/$server_staging/config.toml" "$opt/$watchdog/instances/$server_staging"
