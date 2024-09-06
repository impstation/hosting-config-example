# Server operation details

If you're reading this on the config examples repo: hello, the upstream hosting docs are a bit shit right now so hopefully this helps. examples are king.

This was written to keep the VPS organised and documented which is where you'll be reading this otherwise

## Root directory
`/root` is the home directory for the root directory.

The ssh keys for meda, ghoul, and I (imcb) are in `.ssh/authorized keys` to allow us to connect.

The root directory has the following scripts:
- `backup-config.sh` - Copy appsettings.yml et cetera from various services into `/etc/ss14` to be staged by etckeeper
- `backup-postgres.sh` - Use pg_dump to export data excluding logs into `backup/postgres`. Called by a systemd timer
- `backup-sqlite.sh` - Old script to use sqlite3 to copy data into `backup/server`
- `cdn-update.sh` - Build the game in `src/` and send it to Robust.Cdn with curl. Local alternative to "publish" GitHub action
- `vacuum-replays.sh` - Delete files older than a certain age from the replays server
- `watchdog-update` - Send an update ping instruction to the watchdog with curl

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
- `loki.service` - Runs log aggregator for grafana
- `prometheus.service` - Runs data collector for grafana
- `grafana.service` - Grafana stats server at <https://grafana.impstation.gay>
- `red@.service` - Red bot service to update Discord server status embed
- `robust-cdn.service` - Serves builds at <https://impstation.gay/cdn> allowing better updates and replays
- `ss14-admin.service` - Runs admin panel at <https://impstation.gay/admin>
- `ss14-changelog.service` - Runs auto changelog bot

We also need the stock units `nginx.service` and `postgresql.service` for the web proxying and the Postgres server which is servicing the game server, the Red bot, and grafana.

## Nginx config
Nginx is the web server running our proxies and stuff. The setup is all in `/etc/nginx/sites-available/ss14` and should be commented and self explanatory.

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
- Discord webhooks should be in the game's `discord.*_webhook` as well as the watchdog's `Notification.DiscordWebhook`
- Postgres passwords
    - The server database password should match in the server's `database.pg_password` and in SS14.Admin's `DefaultConnection`
    - The Grafana database is in `database.password`
    - Red bot's password is in its config somewhere

## Relevant docs
- <https://docs.spacestation14.com/en/general-development/setup/server-hosting-tutorial.html>
- <https://docs.spacestation14.com/en/server-hosting/server-replay-recording.html>
- <https://docs.spacestation14.com/en/server-hosting/setting-up-robust-cdn.html>
- <https://docs.spacestation14.com/en/server-hosting/setting-up-ss14-admin.html>
- <https://docs.spacestation14.com/en/server-hosting/setting-up-ss14-watchdog.html>
- <https://docs.spacestation14.com/en/server-hosting/setting-up-redbot.html>
