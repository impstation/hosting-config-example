#!/usr/bin/env bash

set -eux

rsync --archive --recursive --delete /etc/ss14/ ss14

rsync --archive --recursive --delete /root/scripts/ scripts

mkdir -p nginx
cp -t nginx /etc/nginx/sites-available/ss14

mkdir -p systemd
cp -t systemd /etc/systemd/system/{backup-postgres.service,backup-postgres.timer,byobu-watchdog.service,loki.service,'red@.service',robust-cdn.service,ss14-admin.service,ss14-changelog.service,prune-replays.service,prune-replays.timer}
