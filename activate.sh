#!/usr/bin/env bash

# Load environment variables
# TODO: handle hashtags
# shellcheck disable=SC2046
export $(grep -e AWS_ -e S3_ .env | xargs)
export RODONES_ENV=1

alias s4cmd='s4cmd --endpoint-url $S3_ENDPOINT_URL'

PS1="(rodones) $PS1"

rodo_next_index() {
    local current_index
    current_index=$(s4cmd ls "s3://rodones-images/$1/$1_*" | grep -Po "(?<=$1_)([0-9]+)(?=_)" | sort -n | tail -n1)

    [ -z "$current_index" ] && current_index=0
    current_index=$((current_index + 1))

    echo "$current_index"
}
