function [] = visualize_mesh(x_mesh_vector,y_mesh_vector,grid_height, covariance)
%VISUALIZE_MESH Summary of this function goes here
%   Detailed explanation goes here
[X, Y] = meshgrid(y_mesh_vector, x_mesh_vector);
Z = grid_height;
covariance = abs(covariance) .* (abs(covariance) < 0.5);
surf(X, Y, Z, covariance);
axis equal;
xlabel('y');
ylabel('x');
end

