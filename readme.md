# This is a clone of google cartographer, I modified some parameters to work with my robot.
## if you fin this repo you should have a look at this repo:
https://github.com/poplop03/robot1 
## Some of the information you should know about this repo:
- This repo is used to do SLAM with cartographer algorithm.
- The configuration is used to generated 3D or 2D map of the environment with cartographer offline SLAM.
- Critically, check this original program https://google-cartographer-ros.readthedocs.io/en/latest/
## How to use:
- run the bash file `slamSerialized2D.sh` for 2D map generation.
- run the bash file `slamSerialized3D.sh` for 2D map generation.
- For more detail read the 2 bash file.
### 2D SLAM:
![2D SLAM](/docs/pics/carto2D.png)
- Your robot setup must use the topic similar to the topic in the picture, otherwise you can change or remapping by modify `offline_my_robot_custom.launch` and `custom_dynamic_assets_writer_ros_map.launch` to suit your naming convention.
- The output map is in the same folder of the .bag file. For 2D slam you will have .yaml and .pgm file.
### 3D SLAM:
![3D SLAM](/docs/pics/carto3D.png)
- Your robot setup must use the topic similar to the topic in the picture, otherwise you can change or remapping by modify `offline_backpack_3d_custom.launch` and `assets_writer_backpack_3d_custom.launch` to suit your naming convention.
- The output map is in the same folder of the .bag file. For 3D slam you will have the xray of different projection and .xyz and .ply file. then you can use any point cloud viewer to view the generated map. in my case i use Cloud Compare.

### I recommend dig further into the configuration, you will have a better understand how to tune the the SLAM algorithm.
- Some of the parameters i have discovered strongly influence the result:
- TRAJECTORY_BUILDER_2D.num_accumulated_range_data
- num_subdivisions_per_laser_scan

### 2D map result:
![2D map](/docs/pics/map2D.png)
### 3D map result:
![3D map 1](/docs/pics/map3D_1.png)
![3D map 2](/docs/pics/map3D_2.png)

3D result is not very good right now, i am still working on.

