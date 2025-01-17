#!/usr/bin/env bash
set -eux

# publish command:
# dotnet publish -c Release -r linux-x64 --no-self-contained

rsync --archive -P -r /root/src/Robust.Cdn/Robust.Cdn/bin/Release/net9.0/linux-x64/publish/ /opt/Robust.Cdn --dry-run
rsync --archive -P -r /root/src/SS14.Admin/SS14.Admin/bin/Release/net9.0/linux-x64/publish/ /opt/SS14.Admin --dry-run
rsync --archive -P -r /root/src/SS14.Changelog/SS14.Changelog/bin/Release/net8.0/linux-x64/publish/ /opt/SS14.Changelog --dry-run
rsync --archive -P -r /root/src/SS14.Watchdog/SS14.Watchdog/bin/Release/net9.0/linux-x64/publish/ /opt/SS14.Watchdog --dry-run
