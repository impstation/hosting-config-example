#!/usr/bin/env bash

set -eux

rsync --archive --recursive /etc/ss14/ ss14

rsync --archive --recursive /root/scripts/ scripts

mkdir -p nginx
cp -t nginx /etc/nginx/sites-available/ss14

mkdir -p systemd
cp -t systemd /etc/systemd/system/{backup-postgres.service,backup-postgres.timer,byobu-watchdog.service,loki.service,'red@.service',robust-cdn.service,ss14-admin.service,ss14-changelog.service,vacuum-replays.service,vacuum-replays.timer}
