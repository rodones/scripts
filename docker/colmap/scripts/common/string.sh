#!/usr/bin/env bash

indent() {
    local pattern=""
    pattern="$(printf "%0$1s" '' | tr '0' '=')"

    while read -r line; do
        echo "$pattern$line"
    done
}
