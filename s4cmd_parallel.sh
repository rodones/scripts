#!/usr/bin/env bash

[ -z "$1" ] && echo "error: commands file not given." && exit 1
[ ! -f "$1" ] && echo "error: commands file does not exist." && exit 1

source ./activate.sh

xargs -d '\n' -P 8 -I {} bash -c "s4cmd --endpoint-url '$S3_ENDPOINT_URL' {}" <"$1"
