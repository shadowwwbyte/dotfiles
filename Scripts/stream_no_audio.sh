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
-c:v libx264 \
-preset veryfast \
-pix_fmt yuv420p \
-b:v 6000k \
-maxrate 6000k \
-bufsize 12000k \
-g 120 \
-f flv \
"rtmp://live.twitch.tv/app/$STREAM_KEY"
