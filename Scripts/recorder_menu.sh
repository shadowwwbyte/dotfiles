#!/bin/bash

SCRIPTS_DIR="/home/manasa/Scripts"
VIDEOS_DIR="/home/manasa/Videos/My_Videos"

CHOICE=$(printf "󰕧 Record - System Audio\n󰍬 Record - Microphone\n󰝟 Record - No Audio\n󰕃 Stream to Twitch - System Audio\n󰕃 Stream to Twitch - Microphone\n󰕃 Stream to Twitch - No Audio\n󰗃 Stream to YouTube - System Audio\n󰗃 Stream to YouTube - Microphone\n󰗃 Stream to YouTube - No Audio\n󰆏 Convert MKV to MP4\n󰓅 Change Speed\n󰓛 Stop Recording" \
  | rofi -dmenu -p "󰕧 Recorder")

case "$CHOICE" in

  "󰕧 Record - System Audio")
    NAME=$(rofi -dmenu -p "File name (no extension)" < /dev/null)
    [ -z "$NAME" ] && exit 0
    bash "$SCRIPTS_DIR/record_system_audio.sh" "$NAME" &
    ;;

  "󰍬 Record - Microphone")
    NAME=$(rofi -dmenu -p "File name (no extension)" < /dev/null)
    [ -z "$NAME" ] && exit 0
    bash "$SCRIPTS_DIR/record_microphone_audio.sh" "$NAME" &
    ;;

  "󰝟 Record - No Audio")
    NAME=$(rofi -dmenu -p "File name (no extension)" < /dev/null)
    [ -z "$NAME" ] && exit 0
    bash "$SCRIPTS_DIR/record_no_audio.sh" "$NAME" &
    ;;

  "󰕃 Stream to Twitch - System Audio")
    bash "$SCRIPTS_DIR/stream_twitch_system_audio.sh" &
    ;;

  "󰕃 Stream to Twitch - Microphone")
    bash "$SCRIPTS_DIR/stream_twitch_microphone_audio.sh" &
    ;;

  "󰕃 Stream to Twitch - No Audio")
    bash "$SCRIPTS_DIR/stream_twitch_no_audio.sh" &
    ;;

  "󰗃 Stream to YouTube - System Audio")
    bash "$SCRIPTS_DIR/stream_youtube_system_audio.sh" &
    ;;

  "󰗃 Stream to YouTube - Microphone")
    bash "$SCRIPTS_DIR/stream_youtube_microphone_audio.sh" &
    ;;

  "󰗃 Stream to YouTube - No Audio")
    bash "$SCRIPTS_DIR/stream_youtube_no_audio.sh" &
    ;;

  "󰆏 Convert MKV to MP4")
    MKVFILES=$(ls "$VIDEOS_DIR"/*.mkv 2>/dev/null | xargs -I{} basename {})
    if [ -z "$MKVFILES" ]; then
      exit 1
    fi
    FILE=$(echo "$MKVFILES" | rofi -dmenu -p "Pick MKV to convert")
    [ -z "$FILE" ] && exit 0
    bash "$SCRIPTS_DIR/convert.sh" "$VIDEOS_DIR/$FILE"
    ;;

  "󰓅 Change Speed")
    VIDEOFILES=$(ls "$VIDEOS_DIR"/*.mkv "$VIDEOS_DIR"/*.mp4 2>/dev/null | xargs -I{} basename {})
    if [ -z "$VIDEOFILES" ]; then
      exit 1
    fi
    FILE=$(echo "$VIDEOFILES" | rofi -dmenu -p "Pick video")
    [ -z "$FILE" ] && exit 0

    SPEED=$(printf "0.5\n1.25\n1.5\n2\n2.25\n2.5\n3\n4" | rofi -dmenu -p "Speed")
    [ -z "$SPEED" ] && exit 0

    BASENAME="${FILE%.*}"
    EXT="${FILE##*.}"
    OUTPUT="${BASENAME}_${SPEED}x.${EXT}"

    bash "$SCRIPTS_DIR/speed.sh" "$VIDEOS_DIR/$FILE" "$VIDEOS_DIR/$OUTPUT" "$SPEED" &
    ;;

  "󰓛 Stop Recording")
    pkill -INT ffmpeg
    ;;

esac
