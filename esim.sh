#!/bin/bash
usage() {
    echo -e "Usage: $0 [options] BAG_DIR \n \
    [-h,--help] \n \
    [-d,depths] \t Space delimited list of camera depths in meters \n \
    [-b,baselines] \t Space delimited list of baselines in meters" 1>&2;
}
PARAMS=`getopt -o hd:b: --long help,depths:,baselines: \
             -n 'esim.sh' -- "$@"`
if [ $? != 0 ] ; then echo "Invalid options" >&2 ; usage; exit 1 ; fi
eval set -- "$PARAMS"

while true; do
    case "$1" in
        -h | --help)
            usage
            exit 0
            ;;
        -d | --depths)
            depths="$2"
            shift 2
            ;;
        -b | --baselines)
            baselines="$2"
            shift 2
            ;;
        --)
            if [[ -n $2 ]]; then
                shift
                break
            else
                usage
                exit 1
            fi
            ;;
    esac
done

bag_dir=$(realpath $1)
script_dir=$(dirname $(realpath $0))
config="${script_dir}/esim_config.conf"

if [ ! -d "${bag_dir}" ]; then
    echo "Please enter a valid bag dir"
    usage
    exit 1
fi

if [ -z "${depths}" ]; then
    depths="5 10"
fi

if [ -z "${baselines}" ]; then
    baselines=({5..50..5})
fi

for depth in ${depths}
do
    sed -i "23s|.*|--renderer_plane_z=-${depth}|" ${config}

    for baseline in ${baselines}
    do
        sed -i "4s|.*|--path_to_output_bag=${bag_dir}/${depth}mdepth_$(printf '0.%02d' ${baseline})baseline.bag|" ${config}
        sed -i "14s|.*|--calib_filename=${script_dir}/camera_config.yaml|" ${config}
        sed -i "17s|.*|--renderer_texture=${script_dir}/rpg_esim/event_camera_simulator/imp/imp_planar_renderer/textures/rocks.jpg|" ${config}
        sed -i "35s|.*|--trajectory_multiplier_x=$(printf '0.%03d' $(($baseline*5)))|" ${config}
        roslaunch esim_ros esim.launch config:=${config} &
        sleep 1
        tail --pid=$(pgrep esim_node) -f /dev/null
        pgrep -f optic_flow | xargs kill
        sleep 1
        pgrep -f dvs_renderer | xargs kill
        sleep 1
    done
done
