#!/usr/bin/env sh

SCRIPT_DIR="$(
    cd -- "$(dirname "$0")" >/dev/null 2>&1 || exit
    pwd -P
)"

ORG="rodones"
NAME="nexus"
VERSION="latest"

docker build \
    -t "$ORG/$NAME:$VERSION" \
    "$SCRIPT_DIR"
