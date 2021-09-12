# tub_depth_est_esim
This is a student project at the Computational Psychology and Robotic Interactive Perception laboratories of TU Berlin. The project is aim to illustrate depth estimation with the Open Event Camera Simulator and the Event-based Multi-View Stereo developed by the Robotics and Perception Group in the University of Zurich.

We modified the software to fix various unresolved bugs and added a sinusoidal spline function in the camera simulator. The sinusoidal function is achieved by taking the sine of Pi multiplied by the time step for the positional and angular values.

Further information about our inspiration behind the project as well as the equations we used, please read [our wiki page about it](https://github.com/Armsinrius/tub_depth_est_esim/wiki/Project-Idea)
<br /> <br />
# System Dependencies
All dependencies have been tested with Ubuntu 20.04 and ROS Noetic.

```bash
sudo apt-get install python3-catkin-tools python3-vcstool ros-noetic-pcl-ros libproj-dev libglfw3 libglfw3-dev libglm-dev ros-noetic-hector-trajectory-server
```
<br /> <br />
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
<br /> <br />
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
<br /> <br />
Proced to build ESIM and EMVS by running:
```bash
catkin build esim_ros mapper_emvs
source ~/depth_est_esim/devel/setup.bash
```

We generated our data using helper scripts, esim.sh and emvs.sh. To use them, input a directory for the subsequent bags to be stored and accessed.
To demostrate we just create a new directory called "bags" under the current folder

```bash
cd ~/depth_est_esim/tub_depth_est_esim
mkdir bags 
```
Next there is the option listed when calling esim.sh, 
```bash
bash esim.sh
```
One example for presetting depth (in meter) at 1 meter, and baseline (in centremeter) at 5 cm, would be like: (Note, multi input parameters are also possible via arguments like -d"1 5 10" -b"5 10", which will generate 6 bags based on the input value)
```bash
bash esim.sh -d"1" -b"5" ./bags
```
Then proceed to generate the pointcloud file from the bag:
```bash
bash emvs.sh ./bags
```
Note:
esim.sh accepts parameters for custom ground truth depths and baselines.

emvs.sh accepts a parameter for a custom configuration file.

Last, calculate the trimmed mean of the estimated depth output
```bash
python ./depestimate.py -i /path/to/pointcloud.pcd
```
<br /> <br />
# Example and Visualisation
In the "vis_example" folder, you may find some point cloud we generated ex ante. Of course you can follow the instruction and create point cloud based on other groundtruth depths and baselines. This part solely serve as an illustration.<br />
We ran the experiment on 2 sets of different ground truth depth. One is 5 meters and the other set is in 10m depth. The baselines we have used in each set are the same, they are 0.05m, 0.10m, 0.20m, 0.30m, 0.35m, 0.40m, 0.45m, 0.50m. <br />
We also take consider of the effective baseline in this case. Since our simulated event based camera is moving in a nonlinear speed between the baseline therefore the motions it capture in between is not uniform distributed. To balance this effect, we introduce the concept of effective baseline, similar to the concept of effective voltage in the grid. The effective baseline is the original baseline divided by square root 2.

```bash
python ~/depth_est_esim/tub_depth_est_esim/vis_example/errorestimation.py
```
[Visualisation Images](https://github.com/Armsinrius/tub_depth_est_esim/wiki/Pictures-of-the-example-output) can be found in our wiki as well. <br /> <br />
Student: Huidong Hwang; Haoman Zhong
