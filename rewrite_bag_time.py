#!/usr/bin/env python3

import rosbag
import rospy

# Define the offset you want to shift forward by (e.g. ~2023 epoch)
offset_secs = 1700000000.0  # You can adjust this if needed
offset = rospy.Duration.from_sec(offset_secs)

input_bag = '/home/duc/dataLinh/rosbags/Linear0.4_ang0.2/slam_data.bag'
output_bag = '/home/duc/dataLinh/rosbags/Linear0.4_ang0.2/fixed_slam_data.bag'

with rosbag.Bag(output_bag, 'w') as outbag:
    for topic, msg, t in rosbag.Bag(input_bag).read_messages():
        # Shift the timestamp by the offset
        new_t = t + offset
        outbag.write(topic, msg, new_t)

print(f"✅ Rewritten bag saved as: {output_bag}")
