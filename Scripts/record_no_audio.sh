#!/bin/bash

# Inputs:
#   :0.0          → screen capture
#   crf 18        → quality (lower = better)

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
-crf 18 \
-profile:v high \
-level 4.2 \
-pix_fmt yuv420p \
-movflags +faststart \
/home/manasa/Videos/My_Videos/"$1".mkv
