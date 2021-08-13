# tub_depth_est_esim
This is a student project at Computer Vision & Remote Sensing laboratory of TU Berlin. The project is aim to illustrate depth estimation with open event camera simulator and event-based multi-view stereo. 

The original work is from these two repository. 
https://github.com/uzh-rpg/rpg_esim
https://github.com/uzh-rpg/rpg_emvs

Based on their work, we took a tiny step further and intend to estimate the depth of a flatplane using a event camera simulator. The flatplane in the demostrated case is a picture which is parallel to the event camera simulator. The groundtruth depth, as well as the movement are predefined in the simulator, however the event-based multi-view stereo will not detect the predefined groundtruth, but estimate the depth based on the motion info generated by the simulator. 

Then we used a trunacted mean function to get the estimated depth of the flatplane in python and compare with the theoretical value. 
\\[ z_{eps}=\frac{d_{eps}\cdot{P_z}^2}{f\cdot t} \\]

# System Dependencies
All dependencies have been tested with Ubuntu 20.04 and ROS Noetic.

```bash
sudo apt-get install python3-catkin-tools python3-vcstool ros-noetic-pcl-ros libproj-dev libglfw3 libglfw3-dev libglm-dev ros-noetic-hector-trajectory-server
```

# Installation 

Create workspace if needed
```bash
mkdir -p ~/depth_est_esim/src && cd ~/depth_est_esim/
catkin config --init --mkdirs --extend /opt/ros/noetic --merge-devel --cmake-args -DCMAKE_BUILD_TYPE=Release
```

Clone this repository and copy the relavant packages into source folder

```bash
git clone --recurse-submodules -j8 git@github.com:Armsinrius/tub_depth_est_esim.git
cp -r ~/depth_est_esim/tub_depth_est_esim/rpg_emvs ~/depth_est_esim/src
cp -r ~/depth_est_esim/tub_depth_est_esim/rpg_esim ~/depth_est_esim/src
cd src/
```

# Usage and ROS

Clone dependencies:

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
source ~/depth_est_esim/devel/setup.bash
```

We generated our data using helper scripts, esim.sh and emvs.sh. To use them, input a directory for the subsequent bags to be stored and accessed.
To demostrate we just create a new directory called "bags" under the current folder 

```bash
cd ~/depth_est_esim/tub_depth_est_esim
mkdir bags && bash esim.sh ./bags
bash emvs.sh ./bags
```



Student: Huidong Hwang; Haoman Zhong