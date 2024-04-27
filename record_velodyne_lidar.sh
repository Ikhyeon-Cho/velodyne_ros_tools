#!/bin/bash

# Create the directory if it doesn't exist
mkdir -p ~/Downloads/$2

rosbag record -O ~/Downloads/$2/$1 \
  /tf_static \
  /$3/velodyne_packets