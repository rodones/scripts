#!/usr/bin/env sh

IMAGE_LIST="$1"
IMAGES_ROOT="$(dirname "$IMAGE_LIST" | sed 's/\//\\\//g')\/images"

# shellcheck disable=SC2046
ristretto $(sed 's/^/'"$IMAGES_ROOT"'\//g' "$IMAGE_LIST" | tr "\n" " ")