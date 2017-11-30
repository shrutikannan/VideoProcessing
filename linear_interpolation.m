function interpolated_value = linear_interpolation(img, x_prime, y_prime)
    [rows, cols] = size(img);

    % Nearest pixels
    x = floor(x_prime); 
    y = floor(y_prime);
    
    % Boundary conditions
    x(x < 1) = 1;
    y(y < 1) = 1;
    x(x > rows - 1) = rows - 1;
    y(y > cols - 1) = cols - 1;

    % How far is the new point from the pixels
    del_x = x_prime-x;
    del_y = y_prime-y;
    
    % Interpolation
    interpolated_value = (1-del_x) * (1-del_y) * img(x,y) + ...
                            del_x  * (1-del_y) * img(x+1,y) + ...
                         (1-del_x) *    del_y  * img(x,y+1) + ...
                            del_x  *    del_y  * img(x+1,y+1);
                    
%     disp('done') % To help in debugging