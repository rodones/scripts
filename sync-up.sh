#!/usr/bin/env bash

WORK_DIR="${1%/}/"
REMOTE_ROOT="s3://rodones"
WORK_NAME="$(basename "$WORK_DIR")"

s3cmd sync "$WORK_DIR" "$REMOTE_ROOT/$WORK_NAME/"