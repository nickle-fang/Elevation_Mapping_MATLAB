function [x_vector, y_vector, z_vector] = pointcloud_filter ...
    (x_vector, y_vector, z_vector, x_range, y_range, random_choice_num)
%ELEVATION_VISUALIZATION Summary of this function goes here
%   Detailed explanation goes here

% filter by the range of x and y
x_mask = (x_vector < x_range(2)) & (x_vector > x_range(1));
y_mask = (y_vector < y_range(2)) & (y_vector > y_range(1));
total_mask = x_mask & y_mask;

% range filter
x_vector = x_vector(total_mask);
y_vector = y_vector(total_mask);
z_vector = z_vector(total_mask);

% intensity_vector = points_vector(:, 4);
% intensity_vector = intensity_vector(total_mask);

% random choice filter
rand_index = randperm(sum(total_mask));
rand_index = rand_index(1:random_choice_num);
x_vector = x_vector(rand_index);
y_vector = y_vector(rand_index);
z_vector = z_vector(rand_index);
% intensity_vector = intensity_vector(rand_index);

end

