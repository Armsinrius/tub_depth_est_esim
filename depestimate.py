# -*- coding: utf-8 -*-


import numpy as np
import open3d as o3d
from scipy import stats
import matplotlib.pyplot as plt
import array as arr


if __name__ == "__main__":

    parser = argparse.ArgumentParser(description='Plot a reconstructed point cloud in 3D')
    parser.add_argument('-i', '--input', default='pointcloud.pcd', type=str,
                        help='path to the PCD file (default: pointcloud.pcd)')
    args = parser.parse_args()


    pc = o3d.io.read_point_cloud(args.input)
    outarrpc = np.asarray(pc.points)
    estout = outarrpc[:,-1]
    tmout = stats.trim_mean(estout,0.1)
    print(tmout)