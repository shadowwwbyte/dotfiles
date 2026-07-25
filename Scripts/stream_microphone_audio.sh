#!/bin/bash

STREAM_KEY=$(cat ~/.config/twitch_key)

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
-i default \
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
-af "volume=2.0" \
-f flv \
"rtmp://live.twitch.tv/app/$STREAM_KEY"
