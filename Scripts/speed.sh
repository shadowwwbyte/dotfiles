#!/bin/bash

# Usage: ./change_speed.sh input.mp4 output.mp4 SPEED
# SPEED > 1 = faster, SPEED < 1 = slower

if [ $# -lt 3 ]; then
    echo "Usage: $0 <input_file> <output_file> <speed_factor>"
    exit 1
fi

input="$1"
output="$2"
speed="$3"

# Calculate video PTS multiplier
pts=$(awk "BEGIN{print 1/$speed}")

# Check if the input has an audio stream
has_audio=$(ffprobe -v error -select_streams a -show_entries stream=index \
            -of csv=p=0 "$input")

if [ -z "$has_audio" ]; then
    # No audio: only change video speed
    ffmpeg -i "$input" -filter:v "setpts=${pts}*PTS" "$output"
else
    # Audio exists: adjust video and audio
    # atempo only supports 0.5-2.0, so for speeds outside that range, chain filters
    atempo_filter=""
    if (( $(echo "$speed > 2.0" | bc -l) )); then
        n=$(awk "BEGIN{print int($speed/2)}")
        rem=$(awk "BEGIN{print $speed/2^$n}")
        atempo_filter=$(printf "atempo=2.0,"%.0s $(seq 1 $n) "atempo=$rem" )
    elif (( $(echo "$speed < 0.5" | bc -l) )); then
        n=$(awk "BEGIN{print int(log($speed)/log(0.5))}")
        rem=$(awk "BEGIN{print $speed/0.5^$n}")
        atempo_filter=$(printf "atempo=0.5,"%.0s $(seq 1 $n) "atempo=$rem" )
    else
        atempo_filter="atempo=$speed"
    fi

    ffmpeg -i "$input" -filter_complex "[0:v]setpts=${pts}*PTS[v];[0:a]${atempo_filter}[a]" \
           -map "[v]" -map "[a]" "$output"
fi

