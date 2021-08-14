#!/bin/bash
bag_dir=$(realpath $1)
script_dir=$(dirname $(realpath $0))
if [ ! -d "${bag_dir}" ]; then
    echo "Please enter a valid bag path"
    exit 1
fi

for bag in ${bag_dir}/*.bag; do
    rosrun mapper_emvs run_emvs --bag_filename=${bag} --flagfile=${script_dir}/emvs_config.conf
    base=$(basename ${bag} .bag)
    mv dsi.npy ${bag_dir}/${base}.npy
    mv pointcloud.pcd ${bag_dir}/${base}.pcd
done
