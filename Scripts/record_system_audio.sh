#!/bin/bash

# Inputs:
#   :0.0                                           → screen capture
#   $AUDIO_SOURCE                                  → system audio
#   crf 18                                         → quality (lower = better)

if pactl list short sinks | grep -q "8C_0D_D9_43_4C_31"; then
  AUDIO_SOURCE="bluez_output.8C_0D_D9_43_4C_31.1.monitor" # Bluetooth headphones/speaker
else
  AUDIO_SOURCE="alsa_output.pci-0000_00_1f.3.analog-stereo.monitor" # laptop speakers / wired headphones
fi

sleep 1

ffmpeg \
-f x11grab \
-video_size 1920x1200 \
-framerate 60 \
-use_wallclock_as_timestamps 1 \
-thread_queue_size 1024 \
-i :0.0 \
-f pulse \
-thread_queue_size 1024 \
-i "$AUDIO_SOURCE" \
-c:v libx264 \
-preset veryfast \
-crf 18 \
-profile:v high \
-level 4.2 \
-pix_fmt yuv420p \
-c:a aac \
-b:a 192k \
-movflags +faststart \
/home/manasa/Videos/My_Videos/"$1".mkv

# Command to see sources:
# ❯ pactl list short sources

