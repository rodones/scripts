#!/usr/bin/env bash

FPS_DEFAULT="30/60"
OUTPUT_BASENAME="P_%04d.png"

INPUT_FILE="$1"
OUTPUT_DIR="$2"
FPS="${3:-$FPS_DEFAULT}"
THREAD="8"

print_help() {
    echo "Usage: $(basename "$0") INPUT_FILE OUTPUT_DIR [FPS=$FPS_DEFAULT]"
}

[ "$1" = "--help" ] && print_help && exit

if [ -z "$INPUT_FILE" ]; then
    echo "error: input file is not specified."
    exit 1
elif [ ! -f "$INPUT_FILE" ]; then
    echo "error: input file does not exist."
    exit 2
fi

if [ -z "$OUTPUT_DIR" ]; then
    echo "error: output directory is not specified."
    exit 1
elif [ ! -d "$OUTPUT_DIR" ]; then
    echo "error: output directory does not exist."
    exit 2
fi

INPUT_BASENAME="$(basename "$INPUT_FILE")"

if [[ "$INPUT_BASENAME" =~ ^VID_[0-9]{8}_[0-9]{6} ]]; then
    OUTPUT_BASENAME="P_${INPUT_BASENAME:4:15}_%04d.png"
elif [[ "$INPUT_BASENAME" =~ ^V_[0-9]{8}_[0-9]{6} ]]; then
    OUTPUT_BASENAME="P_${INPUT_BASENAME:2:15}_%04d.png"
fi

ffmpeg -i "$INPUT_FILE" -vf fps="$FPS" -threads "$THREAD" "$OUTPUT_DIR/$OUTPUT_BASENAME"
