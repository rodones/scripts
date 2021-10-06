#!/usr/bin/env sh

IMAGE_LIST="$1"
DEST="$2"
BASE="$(dirname "$IMAGE_LIST")/images"

[ ! -d "$DEST" ] && echo "error: $DEST does not exist." && exit 1

while read -r img
do
  mv "$BASE/$img" "$DEST"
done < "$IMAGE_LIST"