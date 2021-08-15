#!/bin/bash
usage() {
    echo -e "Usage: $0 [options] BAG_DIR \n \
    [-h,--help] \n \
    [-c,--config] \t EMVS config file" 1>&2;
}
PARAMS=`getopt -o hc: --long help,config: \
             -n 'emvs.sh' -- "$@"`
if [ $? != 0 ] ; then echo "Invalid options" >&2 ; usage; exit 1 ; fi
eval set -- "$PARAMS"

while true; do
    case "$1" in
        -h | --help)
            usage
            exit 0
            ;;
        -c | --config)
            config=$(echo "${2//=}")
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
if [ ! -d "${bag_dir}" ]; then
    echo "Please enter a valid bag path"
    exit 1
fi

if [ -z "${config}" ]; then
    config=${script_dir}/emvs_config.conf
fi
for bag in ${bag_dir}/*.bag; do
    rosrun mapper_emvs run_emvs --bag_filename=${bag} --flagfile=${config}
    base=$(basename ${bag} .bag)
    mv dsi.npy ${bag_dir}/${base}.npy
    mv pointcloud.pcd ${bag_dir}/${base}.pcd
done
