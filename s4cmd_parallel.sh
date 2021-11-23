#!/usr/bin/env bash

[ -z "$1" ] && echo "error: commands file not given." && exit 1
[ ! -f "$1" ] && echo "error: commands file does not exist." && exit 2
[ -z "$RODONES_ENV" ] && echo "error: environment is not activated." && exit 3

xargs -d '\n' -P 8 -I {} bash -c "s4cmd --endpoint-url '$S3_ENDPOINT_URL' {}" <"$1"
