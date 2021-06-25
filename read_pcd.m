function [points_vector] = read_pcd(pcd_dir, i)
%READ_PCD Summary of this function goes here
%   Detailed explanation goes here
pcd_files_list = {dir(pcd_dir)};

file_path = strcat(pcd_dir, "/", pcd_files_list{1}(i+2).name);
ptCloud = pcread(file_path);
% figure
% pcshow(ptCloud);
points_vector = ptCloud.Location();

sizeof_points_vector = size(points_vector);
point_ones = ones(sizeof_points_vector(1), 1);
points_vector = [points_vector, point_ones];

end

