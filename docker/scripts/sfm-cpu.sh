#!/usr/bin/env sh

BASE="$1"
THREAD_COUNT="${2:-4}"

if [ -z "$BASE" ]; then
   echo "error: working directory is not specified."
   exit 1
elif [ ! -d "$BASE" ]; then
   echo "error: working directory does not exist."
   exit 2
elif [ ! -d "$BASE/images" ]; then
   echo "error: the directory is not working directory. ensure that it has images folder."
   exit 3
fi

BASE="$(realpath "$BASE")"
IMAGES="$BASE/images"
OUTPUT="$BASE/output"

DATABASE="$OUTPUT/database.db"
SPARSE="$OUTPUT/sparse"

[ -d "$OUTPUT" ] || mkdir "$OUTPUT"

colmap feature_extractor \
   --SiftExtraction.use_gpu=false \
   --SiftExtraction.num_thread="$THREAD_COUNT" \
   --database_path "$DATABASE" \
   --image_path "$IMAGES"

colmap exhaustive_matcher \
   --SiftMatching.use_gpu=false \
   --SiftMatching.num_thread="$THREAD_COUNT" \
   --database_path "$DATABASE"

[ -d "$SPARSE" ] || mkdir "$SPARSE"

colmap mapper \
   --database_path "$DATABASE" \
   --image_path "$IMAGES" \
   --output_path "$SPARSE"
