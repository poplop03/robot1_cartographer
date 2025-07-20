#!/bin/bash

# === SETUP ROS ENVIRONMENT ===
source /opt/ros/noetic/setup.bash
source ~/carto/install_isolated/setup.bash

# === CONFIGURATION ===
BAG_DIR="/home/duc/rosbags"
LATEST_BAG=$(ls -t $BAG_DIR/*.bag 2>/dev/null | head -n 1)

if [[ -z "$LATEST_BAG" ]]; then
  echo "No .bag files found in $BAG_DIR"
  exit 1
fi

POSE_GRAPH="${LATEST_BAG}.pbstream"
echo "Using bag file: $LATEST_BAG"
echo "Will save pose graph to: $POSE_GRAPH"

# === STEP 1: RUN OFFLINE SLAM ===
echo "Running Cartographer offline SLAM..."
roslaunch cartographer_ros offline_my_robot_custom.launch bag_filenames:="$LATEST_BAG"

# === STEP 2: SAVE THE POSE GRAPH ===
echo "Saving pose graph to: $POSE_GRAPH"
rosservice call /write_state "{filename: '$POSE_GRAPH'}"

# === STEP 3: GENERATE MAP ===
echo "Generating map files..."
roslaunch cartographer_ros custom_dynamic_assets_writer_ros_map.launch \
    bag_filenames:="$LATEST_BAG" \
    pose_graph_filename:="$POSE_GRAPH"

# === STEP 4: FIND AND RENAME OUTPUTS TO map.pgm / map.yaml ===
PGM_FILE=$(find "$BAG_DIR" -maxdepth 1 -name "*.pgm" -print -quit)
YAML_FILE="${PGM_FILE%.pgm}.yaml"

if [[ -f "$PGM_FILE" && -f "$YAML_FILE" ]]; then
  echo "Renaming:"
  echo " - $PGM_FILE -> $BAG_DIR/map.pgm"
  echo " - $YAML_FILE -> $BAG_DIR/map.yaml"

  mv -f "$PGM_FILE" "$BAG_DIR/map.pgm"
  mv -f "$YAML_FILE" "$BAG_DIR/map.yaml"

  echo "Map ready:"
  echo " - $BAG_DIR/map.pgm"
  echo " - $BAG_DIR/map.yaml"
else
  echo "Could not find map .pgm and .yaml files in $BAG_DIR"
fi
