#!/bin/bash

STREAM_KEY=$(cat ~/.config/youtube_key)

if pactl list short sinks | grep -q "8C_0D_D9_43_4C_31"; then
    AUDIO_SOURCE="bluez_output.8C_0D_D9_43_4C_31.1.monitor"
else
    AUDIO_SOURCE="alsa_output.pci-0000_00_1f.3.analog-stereo.monitor"
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
-pix_fmt yuv420p \
-b:v 6000k \
-maxrate 6000k \
-bufsize 12000k \
-g 120 \
-c:a aac \
-b:a 160k \
-ar 48000 \
-f flv \
"rtmp://a.rtmp.youtube.com/live2/$STREAM_KEY"
