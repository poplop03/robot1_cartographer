#!/bin/bash
# Automatically detect local IP
IP=$(hostname -I | awk '{print $1}')
export ROS_MASTER_URI=http://$IP:11311
export ROS_IP=$IP

# === SETUP ROS ENVIRONMENT ===
source /opt/ros/noetic/setup.bash
source ~/carto/install_isolated/setup.bash

# === CONFIGURATION ===
BAG_FILE="/home/duc/carto_config/bags/slamd102/slam_data.bag"
POSE_GRAPH="/home/duc/carto_config/bags/slamd102/slam_data.bag.pbstream"

# BAG_FILE="/home/duc/laude/slam_data.bag"
# POSE_GRAPH="/home/duc/laude/slam_data.bag.pbstream"

# === STEP 1: RUN OFFLINE SLAM ===
echo "📍 Starting Cartographer Offline SLAM..."
roslaunch cartographer_ros offline_my_robot_custom.launch bag_filenames:="$BAG_FILE"

# === STEP 2: SAVE THE POSE GRAPH ===
echo "💾 Saving pose graph to: $POSE_GRAPH"
rosservice call /write_state "{filename: '$POSE_GRAPH'}"

# === STEP 3: GENERATE OCCUPANCY MAP FILE ===
echo "🗺️ Generating .pgm and .yaml map files..."
roslaunch cartographer_ros custom_dynamic_assets_writer_ros_map.launch \
    bag_filenames:="$BAG_FILE" \
    pose_graph_filename:="$POSE_GRAPH"

echo "✅ SLAM complete! Map saved in same directory as bag."
paplay /usr/share/sounds/freedesktop/stereo/suspend-error.oga
