clc; clear; close all;

img1 = double(imread('Fall_trees_0.tif'));
img2 = double(imread('Fall_trees_5.tif'));

[rows, cols,ch] = size(img1);
A = [1,0;0,1];
b = [0; 0];
lambda = 10^-5;

it = 0;
b2 = 0;
b2_new = 1;
while abs(b2_new - b2) >= 0.05 % minimising wrt a22
    b2 = b2_new;
    b(2) = b2;
    derivative_cost_b2 = 0;
    for row = 1:rows
        for col = 1:cols
            x = [row, col]';           
            x_prime = A*x + b;
            
            if x_prime(1)<0 || x_prime(1)>rows || x_prime(2)<0 ||x_prime(2)>cols || x_prime(1)+1>rows || x_prime(2)+1>cols || x(2)+1>rows
%                 disp('Out of Bounds')
                continue;
            end
            
            interpolated_img2 = linear_interpolation(img2, x_prime(1), x_prime(2));

            tmp1 = -2 * (img1(x(1), x(2)) - interpolated_img2);
            tmp2 = img2(x(1), x(2)) - img2(x(1), x(2)+1);
            tmp3 = 1;
            derivative_cost_b2 = (derivative_cost_b2 + (tmp1 * tmp2 * tmp3)); % Summing up the minimised cost function for all pixels fo the image 
        end
    end
    b2_new = b(2) - lambda * derivative_cost_b2;
    it = it + 1;
end