% clear the workspace
clear
clc

% config
x_range = [-10, 10];
y_range = [-10, 10];
random_choice_num = 10000;
grid_resolution = 0.2;
gt_pose = load("./kitti_gt/data_odometry_poses/dataset/poses/00.txt");

% transforme matrix
% P_camera = Tr * P_lidar
Tr = [4.276802385584e-04, -9.999672484946e-01, -8.084491683471e-03, -1.198459927713e-02;
     -7.210626507497e-03, 8.081198471645e-03,  -9.999413164504e-01, -5.403984729748e-02;
      9.999738645903e-01, 4.859485810390e-04,  -7.206933692422e-03, -2.921968648686e-01;
      0,                  0,                   0,                   1                 ];
Tz = [1, 0, 0, 0;
      0, 0, 1, 0;
      0,-1, 0, 0;
      0, 0, 0, 1];

old_height = NaN;
old_center = [0,0];
new_center = [0,0];
xyz = [];
for lidar_frame_i = 1:960
    points_vector = read_pcd("./kitti_gt/00_kitti_pcd", lidar_frame_i);
    
    gt_pose_i = gt_pose(lidar_frame_i,:);
    gt_pose_i = reshape(gt_pose_i, [4,3]);
    gt_pose_i = gt_pose_i';
    row_ones = [0,0,0,1];
    gt_pose_i = [gt_pose_i; row_ones];
    
    % handle the transformation and rotation
    total_transform_matrix = Tz * gt_pose_i * Tr;
    points_vector = total_transform_matrix * points_vector';
    points_vector = points_vector';
    
    x_vector = points_vector(:, 1);
    y_vector = points_vector(:, 2);
    z_vector = points_vector(:, 3);
    
    % filter the pointcloud
    x_vector = x_vector - total_transform_matrix(1,4);
    y_vector = y_vector - total_transform_matrix(2,4);
    z_vector = z_vector - total_transform_matrix(3,4);
    [x_vector, y_vector, z_vector] = pointcloud_filter ...
        (x_vector, y_vector, z_vector, x_range, y_range, random_choice_num);
    x_vector = x_vector + total_transform_matrix(1,4);
    y_vector = y_vector + total_transform_matrix(2,4);
    z_vector = z_vector + total_transform_matrix(3,4);
    
    % debug show points
    % scatter3(x_vector, y_vector, z_vector, ".");
    % xlabel('x');
    % ylabel('y');
    % axis equal;
    % pause(1);
    % hold on;

    % update elevation height
    new_center = [total_transform_matrix(1,4),total_transform_matrix(2,4)];
    [grid_height, covariance] = update_grid_height ...
      (lidar_frame_i,x_range,y_range,grid_resolution, ...
      x_vector,y_vector,z_vector,old_height,old_center,new_center);
    old_height = grid_height;
    old_center = new_center;
    
    disp(new_center);

    % visualize mesh
    x_mesh_vector = (x_range(1)+new_center(1) : grid_resolution : x_range(2)+new_center(1)-grid_resolution);
    y_mesh_vector = (y_range(1)+new_center(2) : grid_resolution : y_range(2)+new_center(2)-grid_resolution);
    visualize_mesh(x_mesh_vector,y_mesh_vector,grid_height, covariance);
    pause(0.001)

end

