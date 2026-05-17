#!/bin/bash

# Inputs:
#   :0.0          → screen capture
#   default       → microphone
#   volume=2.0    → boost mic volume
#   crf 18        → quality (lower = better)

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
-crf 18 \
-profile:v high \
-level 4.2 \
-pix_fmt yuv420p \
-c:a aac \
-b:a 192k \
-af "volume=2.0" \
-movflags +faststart \
/home/manasa/Videos/My_Videos/"$1".mkv
