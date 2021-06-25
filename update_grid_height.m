function [new_grid_height, covariance] = update_grid_height ...
(frame_id,x_range,y_range,grid_resolution,x_vector,y_vector,z_vector,old_height,old_center,new_center)
%UPDATE_GRID_HEIGHT Summary of this function goes here
%   Detailed explanation goes here

grid_x_number = (x_range(2)-x_range(1))/grid_resolution;
grid_y_number = (y_range(2)-y_range(1))/grid_resolution;

if frame_id == 1
    % split some grid and cal each height of the grid
    grid_height = zeros(grid_x_number, grid_y_number);
    for grid_x_i = (1:grid_x_number)
        for grid_y_i = (1:grid_y_number)
            grid_x_min = x_range(1) + (grid_x_i-1) * grid_resolution;
            grid_x_max = grid_x_min + grid_resolution;

            grid_y_min = y_range(1) + (grid_y_i-1) * grid_resolution;
            grid_y_max = grid_y_min + grid_resolution;

            grid_choice_x_mask = x_vector>=grid_x_min & x_vector<grid_x_max;
            grid_choice_y_mask = y_vector>=grid_y_min & y_vector<grid_y_max;
            grid_choice_total_mask = grid_choice_x_mask & grid_choice_y_mask;

            if sum(grid_choice_total_mask) > 0
                gird_choice_height_vector = z_vector(grid_choice_total_mask);
                grid_height(grid_x_i, grid_y_i) = max(gird_choice_height_vector);
            else
                grid_height(grid_x_i, grid_y_i) = NaN;
            end
        end
    end
    new_grid_height = grid_height;
    [dx, dy] = gradient(new_grid_height);
    covariance = dx + dy;
else
    grid_height = zeros(grid_x_number, grid_y_number);
    for grid_x_i = (1:grid_x_number)
        for grid_y_i = (1:grid_y_number)
            x_move_grid_num = round((new_center(1) - old_center(1)) / grid_resolution);
            y_move_grid_num = round((new_center(2) - old_center(2)) / grid_resolution);
            
            grid_x_min = x_range(1) + new_center(1) + (grid_x_i-1) * grid_resolution;
            grid_x_max = grid_x_min + grid_resolution;

            grid_y_min = y_range(1) + new_center(2) + (grid_y_i-1) * grid_resolution;
            grid_y_max = grid_y_min + grid_resolution;
            
            grid_choice_x_mask = x_vector>=grid_x_min & x_vector<grid_x_max;
            grid_choice_y_mask = y_vector>=grid_y_min & y_vector<grid_y_max;
            grid_choice_total_mask = grid_choice_x_mask & grid_choice_y_mask;

            if sum(grid_choice_total_mask) > 0
                gird_choice_height_vector = z_vector(grid_choice_total_mask);
                grid_height(grid_x_i, grid_y_i) = max(gird_choice_height_vector);
            else
                if (grid_x_i + x_move_grid_num > 0) && (grid_x_i + x_move_grid_num <= grid_x_number) ...
                   && (grid_y_i + y_move_grid_num > 0) && (grid_y_i + y_move_grid_num <= grid_y_number)
                    grid_height(grid_x_i, grid_y_i) = old_height(grid_x_i + x_move_grid_num, grid_y_i + y_move_grid_num);
                else
                    grid_height(grid_x_i, grid_y_i) = NaN;
                end
            end
        end
    end
    new_grid_height = grid_height;
    [dx, dy] = gradient(new_grid_height);
    covariance = dx + dy;
    
end

end

