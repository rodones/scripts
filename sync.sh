#!/usr/bin/env bash

REMOTE_ROOT="s3://rodones"

if [ "$1" = "up" ]; then
    FROM="${2%/}/"
    TO="$REMOTE_ROOT/$(basename "$FROM")/"
elif [ "$1" = "down" ]; then
    TO="${2%/}/"
    FROM="$REMOTE_ROOT/$(basename "$TO")/"
else
    echo "error: found $1, expected: up, down."
    exit 1
fi

echo "Are you sure to update '$TO' according to '$FROM'?"
select yn in "Yes" "No"; do
    case $yn in
    Yes)
        s3cmd sync --verbose --no-preserve "$FROM" "$TO"
        break
        ;;
    No)
        exit
        ;;
    esac
done
