#!/usr/bin/env bash

set -eux

# https://github.com/impstation/imp-station-14/actions/workflows/publish.yml
# https://github.com/impstation/imp-station-14/blob/master/.github/workflows/publish.yml

ROBUST_CDN_URL='https://cdn.impstation.gay'
FORK_ID='impstation'
PUBLISH_TOKEN='REDACTED1'
ARTIFACT_URL='https://impstation.gay/artifacts/artifacts.zip'

REPO_PATH="$HOME/src/imp-station-14"
ARTIFACT_FILE='/var/www/artifacts/artifacts.zip'
ENDPOINT_URL="$ROBUST_CDN_URL/fork/$FORK_ID/publish"

version=$(git -C "$REPO_PATH" rev-parse HEAD)
engine_version=$(git -C "$REPO_PATH/RobustToolbox" describe --tags --abbrev=0)
engine_version="${engine_version:1}"

# build
cd "$REPO_PATH"
git pull --ff-only
dotnet restore
dotnet build Content.Packaging --configuration Release --no-restore
dotnet run --project Content.Packaging server --platform win-x64 --platform linux-x64 --platform osx-x64 --platform linux-arm64
dotnet run --project Content.Packaging client --no-wipe-release

# zip the build
bsdtar -cf "$ARTIFACT_FILE" --cd "$REPO_PATH/release" \
    SS14.Client.zip SS14.Server_linux-arm64.zip SS14.Server_linux-x64.zip SS14.Server_osx-x64.zip SS14.Server_win-x64.zip

# send to cdn
curl \
    -v \
    -X 'POST' \
    --header 'Content-Type: application/json' \
    --header "Authorization: Bearer $PUBLISH_TOKEN" \
    --data "{\"version\": \"$version\", \"engineVersion\": \"$engine_version\", \"archive\": \"$ARTIFACT_URL\"}" \
    "$ENDPOINT_URL"
