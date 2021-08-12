# tub_depth_est_esim
TU Berlin depth estimation with open event camera simulator

# System Dependencies
All dependencies have been tested with Ubuntu 20.04 and ROS Noetic.

```bash
sudo apt-get install python-catkin-tools python-vcstool ros-noetic-pcl-ros libproj-dev libglfw3 libglfw3-dev libglm-dev ros-noetic-hector-trajectory-server
```

# Usage and ROS
To use this package, please copy the rpg_esim and rpg_emvs packages into your catkin workspace. To install the ROS dependencies, in the src/ directory run:

```bash
vcs-import < rpg_esim/dependencies.yaml
vcs-import < rpg_emvs/dependencies.yaml
cd ze_oss
touch imp_3rdparty_cuda_toolkit/CATKIN_IGNORE \
      imp_app_pangolin_example/CATKIN_IGNORE \
      imp_benchmark_aligned_allocator/CATKIN_IGNORE \
      imp_bridge_pangolin/CATKIN_IGNORE \
      imp_cu_core/CATKIN_IGNORE \
      imp_cu_correspondence/CATKIN_IGNORE \
      imp_cu_imgproc/CATKIN_IGNORE \
      imp_ros_rof_denoising/CATKIN_IGNORE \
      imp_tools_cmd/CATKIN_IGNORE \
      ze_data_provider/CATKIN_IGNORE \
      ze_geometry/CATKIN_IGNORE \
      ze_imu/CATKIN_IGNORE \
      ze_trajectory_analysis/CATKIN_IGNORE
```

Proced to build ESIM and EMVS by running:
```bash
catkin build esim_ros mapper_emvs
```

We generated our data using helper scripts, esim.sh and emvs.py. To use them, input a directory for the subsequent bags to be stored and accessed.

Student: Huidong Hwang; Haoman Zhong
