#!/bin/bash

# Exit if no input provided
if [ -z "$1" ]; then
  echo "Usage: $0 <input.mkv>"
  exit 1
fi

INPUT="$1"

# Check if file exists
if [ ! -f "$INPUT" ]; then
  echo "Error: File not found: $INPUT"
  exit 1
fi

# Strip extension
BASENAME="${INPUT%.*}"

OUTPUT="${BASENAME}_C.mp4"

ffmpeg -i "$INPUT" -c copy "$OUTPUT"


# USAGE:
# ./convert.sh input.mkv
#
# OUTPUT
# input_C.mp4
