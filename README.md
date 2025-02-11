# Server operation details

If you're reading this on the config examples repo: hello, the upstream hosting docs are a bit shit right now so hopefully this helps. examples are king.

This was written to keep the VPS organised and documented which is where you'll be reading this otherwise. If so hi and check out `~/.bash_history` and `~/.local/share/fish/fish_history` if any steps are unclear and that might help

## Root directory
`/root` is the home directory for the root directory.

The ssh keys for meda, ghoul, and I (imcb) are in `.ssh/authorized keys` to allow us to connect.

The root directory has the following scripts:
- `backup-config.sh` - (OLD - I realised you can just use symlinks) Copy appsettings.yml et cetera from various services into `/etc/ss14` to be staged by etckeeper
- `backup-postgres.sh` - Use pg_dump to export data excluding logs into `backup/postgres`. Called by a systemd timer
- `backup-sqlite.sh` - Old script to use sqlite3 to copy data into `backup/server`
- `cdn-update.sh` - Build the game in `src/` and send it to Robust.Cdn with curl. Local alternative to "publish" GitHub action
- `make-config-symlinks.sh` - Run once to link files in `/etc/ss14` to everywhere needed in `/opt` to allow easily versioning them with etckeeper. You need to create the files in `/etc/ss14` first.
- `restore-postgres.sh` - Example of how to restore snapshot taken with `backup-postgres.sh`
- `update-installs-dry-run.sh` - Check whether the manually installed dotnet software builds need installing.
- `vacuum-replays.sh` - Delete files older than a certain age from the replays server
- `watchdog-update` - Send an update ping instruction to the watchdog with curl

### Offsite backups
`backup-postgres.sh` will now copy snapshots into the home directory of the `backup_egress` user. I have a separate server which is set up with ssh access to that user only. It will run the scripts in `scripts/offsite` to periodically pull them out of there. Since this server can't access the offsite, only vice versa, if this server was accessed maliciously the backups would still be safe.

The root directory contains the `src/` directory, which has the git source trees of all the ss14 software we're using. These are used to build the dotnet applications and then they're copied into `/opt` where we run them.

Example:
```sh
cd ~/src/SS14.Changelog
dotnet publish -c Release -r linux-x64 --no-self-contained
rsync --archive -P -r ~/src/SS14.Changelog/SS14.Changelog/bin/Release/net8.0/linux-x64/publish/ /opt/SS14.Changelog
```

rsync allows us to see which files have changed.

## Systemd units
The following custom systemd units are automatically running software. They are placed in `/etc/systemd/system` and versioned with etckeeper.
- `backup-postgres.timer`, `backup-postgres.service` - Periodically run `/root/backup-postgres.sh`
- `vacuum-replays.timer`, `vacuum-replays.service` - Periodically run `/root/vacuum-replays.sh`
- `byobu-watchdog.service` - Starts a tmux session and runs the watchdog in it as soon as the server boots up. Allows us to do fully unattended upgrades but still access the server console.
- `loki.service` - Runs log aggregator for grafana
- `prometheus.service` - Runs data collector for grafana
- `grafana.service` - Grafana stats server at <https://grafana.impstation.gay>
- `red@.service` - Red bot service to update Discord server status embed
- `robust-cdn.service` - Serves builds at <https://impstation.gay/cdn> allowing better updates and replays
- `ss14-admin.service` - Runs admin panel at <https://impstation.gay/admin>
- `ss14-changelog.service` - Runs auto changelog bot

We also need the stock units `nginx.service` and `postgresql.service` for the web proxying and the Postgres server which is servicing the game server, the Red bot, and grafana.

NOTE: doing an `apt update` with a new dotnet runtime will cause needrestart to try to automatically restart stuff. You can put `byobu-watchdog` in the blocklist in needrestart config to prevent hiccups

## Nginx config
Nginx is the web server running our proxies and stuff. The setup is all in `/etc/nginx/sites-available/ss14` and should be commented and somewhat self explanatory. You will need the docs, links at the end.

TLS stuff was set up with `certbot --nginx -d impstation.gay -d cdn.impstation.gay -d grafana.impstation.gay` and then copying some bits around to config sections it missed.

## The watchdog
The watchdog is the main piece of software, responsible for spooling up and auto-restarting the game server. It's next to the other software at `/opt/SS14.Watchdog` but instead of a systemd service it's running in a terminal screen so we can access the server console. Use `tmux ls` to list the session and `byobu-select-session` to connect. All that's happening in there is `cd /opt/SS14.Watchdog` and then `./SS14.Watchdog`. If you need to restart the watchdog just use ctrl+c to stop it then run `./SS14.Watchdog` again.

### Game server deployments
The way server updates work now is you should go to <https://github.com/impstation/imp-station-14/actions/workflows/publish.yml> and click "Run workflow". that will build the server and client then send it to the CDN. the cdn sends a ping to the watchdog and then at the end of the round the watchdog will automatically restart the server. so it should be one-click anytime upgrade. if you want to not use github actions I put `/root/cdn-update.sh` which should work

## Tokens
Auth tokens in the config can be any text, the same token just has to match in corresponding config files. I used bitwarden to generate simple three word passwords but they can be anything as long as it matches.

We have the following tokens to think about:
- Watchdog instance tokens should match in the watchdog's per-instance `ApiToken` and the CDN's `ApiToken`. It's also used in `watchdog-update.sh`.
- The CDN's isntance tokens should match in its `UpdateToken` and in GitHub Actions' `PUBLISH_TOKEN` as well as in `cdn-update.sh`.
- The changelog bot's token should match in its `GitHubSecret` and in the GitHub webhook settings
- The admin panel's `Auth.ClientSecret` should match centcomm's dev settings one
    - <https://account.spacestation14.com/Identity/Account/Manage/Developer>
- Discord webhooks should be in the game's `discord.*_webhook` as well as the watchdog's `Notification.DiscordWebhook`
- Postgres passwords
    - The server database password should match in the server's `database.pg_password` and in SS14.Admin's `DefaultConnection`
    - The Grafana database is in `database.password`
    - Red bot's password is in its config somewhere

## Large disk space users
- client builds at `/var/robust-cdn/builds/`
- server replays at `/opt/SS14.Watchdog/instances/impstation/data/www/replays`
- database at `/var/lib/postgresql/16/main/`

you can view these with `du --human-readable --summarize /var/robust-cdn/builds/ /opt/SS14.Watchdog/instances/impstation/data/ /var/lib/postgresql/16/main/`

## Relevant docs
### SS14 wiki
- <https://docs.spacestation14.com/en/general-development/setup/server-hosting-tutorial.html>
- <https://docs.spacestation14.com/en/server-hosting/server-replay-recording.html>
- <https://docs.spacestation14.com/en/server-hosting/setting-up-robust-cdn.html>
- <https://docs.spacestation14.com/en/server-hosting/setting-up-ss14-admin.html>
- <https://docs.spacestation14.com/en/server-hosting/setting-up-ss14-watchdog.html>
- <https://docs.spacestation14.com/en/server-hosting/oauth.html>
- <https://docs.spacestation14.com/en/server-hosting/setting-up-redbot.html>
### Red bot
- <https://docs.discord.red/en/stable/install_guides/ubuntu-2404.html>
### Nginx
- <https://nginx.org/en/docs/>
### Grafana
- <https://grafana.com/docs/grafana/latest/setup-grafana/installation/debian/>
- <https://grafana.com/tutorials/run-grafana-behind-a-proxy/>
- <https://grafana.com/docs/grafana/latest/setup-grafana/configure-grafana/>
- <https://grafana.com/docs/grafana/latest/setup-grafana/configure-security/configure-authentication/github/>
- <https://grafana.com/docs/grafana/latest/setup-grafana/configure-security/configure-authentication/generic-oauth/>
