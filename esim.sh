#!/bin/bash
bag_dir=$1

if [ ! -d "bag_dir" ]; then
    echo "Please enter a valid bag path"
    exit 1
fi

for depth in 5 10
do
    sed -i "23s/.*/--renderer_plane_z=-${depth}/" esim_config.conf

    for baseline in {5..50..5}
    do
        sed -i "4s|.*|--path_to_output_bag=${bag_dir}/${depth}mdepth_$(printf '0.%02d' ${baseline})baseline.bag|" esim_config.conf
        sed -i "35s|.*|--trajectory_multiplier_x=$(printf '0.%03d' $(($baseline*5)))|" esim_config.conf
        roslaunch esim_ros esim.launch config:=esim_config.conf &
        sleep 1
        tail --pid=$(pgrep esim_node) -f /dev/null
        pgrep -f optic_flow | xargs kill
        sleep 1
        pgrep -f dvs_renderer | xargs kill
        sleep 1
        exit
    done
done
