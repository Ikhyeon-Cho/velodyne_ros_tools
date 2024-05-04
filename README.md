# Velodyne ROS Tools

## Overview

The repository provides the `velodyne_ros_tools` ROS package, which wrapped [official velodyne ROS driver](https://github.com/ros-drivers/velodyne) for running VLP-16 sensor manufactured by Velodyne LiDAR.

There are three main functionalities (in simple [ROS launch](http://wiki.ros.org/roslaunch) files) that is supported in this package:
- `VLP16_points.launch`: Namespace configuration of multiple VLP-16 LiDARs by its arguments
- `VLP16_record.launch`: Recording LiDAR packets in [rosbag](http://wiki.ros.org/rosbag), which significantly reduces the saved file size
- `VLP16_from_rosbag.launch`: Playback command with visualization of rosbag msgs after recording LiDAR packets

## Installation
### Prerequisite
This package is a simple wrapper for the official `velodyne_pointcloud` package. Therefore, you should ensure the installation of the package first.

To install ROS driver, use the following command:
```
sudo apt install ros-noetic-velodyne-pointcloud
```
If you need, see more details in [Getting Started with the Velodyne VLP 16](https://wiki.ros.org/velodyne/Tutorials/Getting%20Started%20with%20the%20Velodyne%20VLP16) pages.


### Build package
After the prerequisite configuration, use the following commands to download and compile the package.
```
cd ~/catkin_ws/src   # navigate to your workspace
git clone https://github.com/Ikhyeon-Cho/velodyne_ros_tools.git
cd ..
catkin build velodyne_ros_tools    # or catkin_make
```
## Getting Started
### 1. Run the device
To start running Velodyne VLP-16 LiDAR, you should connect to the device first. After, use the command below:
```
roslaunch velodyne_ros_tools VLP16_points.launch
```
To launch with `rviz` for data stream visualization, use the command below:
```
roslaunch velodyne_ros_tools test_VLP16_points.launch
```
You can give several command-line arguments to the launch files.
- **`frame_id`** (string, default: velodyne)<br>
  The frame id of the LiDAR sensor. This argument is especially useful when you utilize multiple LiDARs. The argument `frame_id` automatically sets namespace in the nodelets and topics by its value.

- **`device_ip`** (default: 192.168.1.201)<br>
  The ip address of the Velodyne LiDAR.

- **`port`** (default: 2368)<br>
  The port number of the Velodyne LiDAR.

Here is an example command using launch argument options:
```
# You can use multiple Velodyne LiDARs like this:
# Publish 'velodyne_front/points' from velodyne_front LiDAR
# Publish 'velodyne_back/points' from velodyne_back LiDAR

roslaunch velodyne_ros_tools VLP16_points.launch frame_id:=velodyne_front
roslaunch velodyne_ros_tools VLP16_points.launch frame_id:=velodyne_back 

```
### 2. Record data
To record the pointcloud streams, use the command below. Before starting the records, make sure that the device is running.
```
roslaunch velodyne_ros_tools VLP16_record.launch    # Default: 'velodyne_lidar.bag' is saved to {$HOME}/Downloads/ 
```
The command will save the rosbag file to `$HOME/Downloads` folder. By default, the name of rosbag is `velodyne_lidar.bag`.

For assigning a specific name to the rosbag, use the command with `bag_file:=` launch argument like below:
```
roslaunch velodyne_ros_tools VLP16_record.launch bag_file:=example.bag    # now, 'example.bag' is saved
```

When you specify the `project_dir:=` argument, the rosbag is saved in `{$HOME}/Downloads/{project-dir-value}` like below:
```
roslaunch velodyne_ros_tools VLP16_record.launch project_dir:=outdoor_navigation

# now, bag file is saved to {$HOME}/Downloads/outdoor_navigation/
```
If you use multiple LiDARS and aim to record each data streams, then you can specify the `frame_id` arguments like below:
```
# For recording with the frame id: velodyne_front 
roslaunch velodyne_ros_tools VLP16_record.launch frame_id:=velodyne_front
```

### 3. Data playback
To playback the recorded rosbag, use the following command. By default, we assume that rosbag files are located at `{$HOME}/Downloads` folder.
```
# Playback velodyne_lidar.bag
roslaunch velodyne_ros_tools VLP16_from_rosbag.launch bag_file:=velodyne_lidar.bag   
```

You can give several command-line arguments to the launch files.
- **`bag_file`** (string, default: velodyne_lidar.bag)<br>
  The bagfile name for playing.

- **`project_dir`** (string, default: "")<br>
The project directory of bagfile in ~/Downloads/.

- **`playback_speed`** (double, default: 1.0)<br>
The playback speed of bagfile.

- **`start_time`** (double, default: 0.0)<br>
The start time of bagfile playback.