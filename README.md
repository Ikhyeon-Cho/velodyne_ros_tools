# Realsense ROS Tools

## Overview

The repository provides the `realsense_ros_tools` ROS package, which wrapped [realsense-ros/ros1-legacy](https://github.com/IntelRealSense/realsense-ros/tree/ros1-legacy) for running RGB-D cameras manufactured by Intel Realsense.

## Installation
### Prerequisite
This package is a simple wrapper for the official `realsense2_camera` package. Therefore, you should ensure the installation of the package first.

To install [Realsense SDK 2.0](https://github.com/IntelRealSense/librealsense), use the command below:
```
sudo mkdir -p /etc/apt/keyrings
curl -sSf https://librealsense.intel.com/Debian/librealsense.pgp | sudo tee /etc/apt/keyrings/librealsense.pgp > /dev/null
echo "deb [signed-by=/etc/apt/keyrings/librealsense.pgp] https://librealsense.intel.com/Debian/apt-repo `lsb_release -cs` main" | \
sudo tee /etc/apt/sources.list.d/librealsense.list
sudo apt update
sudo apt install librealsense2-dkms librealsense2-utils
```
To install ROS driver, use the following command:
```
sudo apt install ros-noetic-realsense2-camera ros-noetic-rgbd-launch
```
If you need, see more details in Realsense ROS Wrapper [Installation Instructions](https://github.com/IntelRealSense/realsense-ros/tree/ros1-legacy#installation-instructions).

We utilize [rosbag](http://wiki.ros.org/rosbag/Commandline) for logging the data stream. Install `rosbag_fancy` package by using the command below:
```
sudo apt install ros-noetic-rosbag-fancy
```
If you need, see more details about [rosbag_fancy](https://github.com/xqms/rosbag_fancy).

### Build package
After the prerequisite configuration, use the following commands to download and compile the package.
```
cd ~/catkin_ws/src   # navigate to your workspace
git clone https://github.com/Ikhyeon-Cho/realsense_ros_tools.git
cd ..
catkin build realsense_ros_tools    # or catkin_make
```
## Getting Started
### 1. Run the device
To start running Realsense RGB-D camera, you should connect to the device first. After, use the command below:
```
roslaunch realsense_ros_tools rs_camera.launch
```
To launch with `rviz` for data stream visualization, use the command below:
```
roslaunch realsense_ros_tools test_rs_camera.launch
```
You can give several command-line arguments to the launch files.
- **`align_depth`** (bool, default: true)<br>
  When set to **true**, depth image resized and aligned to the RGB image is published. Also, **sensor_msgs/PointCloud2** ROS message that has RGB8 field is published.

- **`fps`** (int, default: 15)<br>
  Camera image fps (frame per second). The driver natively supports 15/30/60/90 fps values. Any other values will result in the setting of 30 FPS, which is the device default.

Here is an example command using launch argument options:
```
# FPS: 30Hz
# No Depth alignment, no point clouds published

roslaunch realsense_ros_tools rs_camera.launch fps:=30 align_depth:=false
```
### 2. Record data
To record the image streams, use the command below. Before starting the records, make sure that the device is running.
```
roslaunch realsense_ros_tools rs_record.launch    # Default: 'rs_camera.bag' is saved to ~/Downloads folder
```
The command will save the rosbag file to `$HOME/Downloads` folder. By default, the name of rosbag is `rs_camera.bag`.

For assigning a specific name to the rosbag, use the command with `bag_file:=` launch argument like below:
```
roslaunch realsense_ros_tools rs_record.launch bag_file:=example.bag    # now, 'example.bag' is saved
```

### 3. Data playback
To playback the recorded rosbag, use the following command. By default, we assume that rosbag files are located at `~/Downloads` folder.
```
roslaunch realsense_ros_tools rs_from_rosbag.launch bag_file:=rs_camera.bag   # Playback rs_camera.bag
```
To launch with `rviz` for data stream visualization, use the command below:
```
roslaunch realsense_ros_tools test_rs_from_rosbag.launch bag_file:=rs_camera.bag    # With Rviz visualization
```
You can give several command-line arguments to the launch files.
- **`bag_file`** (string, default: rs_camera.bag)<br>
  The bagfile name for playing.

- **`enable_pointcloud`** (bool, default: true)<br>
  When set to **true**, **sensor_msgs/PointCloud2** ROS message that has RGB8 field is published. This is done by using `depth_image_proc/point_cloud_xyzrgb` nodelet. It reproduces the pointclouds from RGB image and (aligned) Depth image.

- **`playback_speed`** (double, default: 1.0)<br>
The playback speed of bagfile.

- **`start_time`** (double, default: 0.0)<br>
The start time of bagfile playback.