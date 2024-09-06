#!/usr/bin/env bash

set -eux

cp -r /etc/ss14 opt/
mv opt/README.md .

mkdir -p nginx
cp /etc/nginx/sites-available/ss14 nginx/

mkdir -p systemd
cp -t systemd /etc/systemd/system/{backup-postgres.service,backup-postgres.timer,loki.service,prometheus.service,'red@.service',robust-cdn.service,ss14-admin.service,ss14-changelog.service,vacuum-replays.service,vacuum-replays.timer}
