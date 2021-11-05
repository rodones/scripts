#!/usr/bin/env bash

# Load environment variables
# TODO: handle hashtags
# shellcheck disable=SC2046
export $(grep -e AWS_ -e S3_ .env | xargs)

alias s4cmd='s4cmd --endpoint-url $S3_ENDPOINT_URL'

PS1="(rodones) $PS1"