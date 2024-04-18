#!/bin/bash

# Create the directory if it doesn't exist
mkdir -p ~/Downloads/$2

rosbag_fancy record --lz4 -o ~/Downloads/$2/$1 \
  /$3/velodyne_packets \
  /tf_static