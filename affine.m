clc; clear; close all;
img1 = double(imread('Fall_trees_0.tif'));
img2 = double(imread('Fall_trees_5.tif'));
n = 20;
p = 1;
q = 1;
% [img1, img2] = create_img(n, p, q);
% imshow(img1)
% figure
% imshow(img2)

[rows, cols,ch] = size(img1);

A = [1,0;0,1];
b = [0; 0];
lambda = 10^-4;
% a11 = A(1,1);
x_vec = 1:rows;
y_vec = 1:cols;
[X,Y] = meshgrid(y_vec, x_vec);

a11 = 0;
a11_new = A(1,1);
while (a11_new - a11) >= 0.005 % minimising wrt a11
    a11 = a11_new;
    A(1,1) = a11;
    derivative_cost_a11 = 0;
    for row = 1:rows
        for col = 1:cols
            x = [row, col]';
    %         x1 = [x(1) - cols/2]            
            x_prime = A*x + b;            
%             x_prime = ceil(x_prime);
            if x_prime(1)>rows || x_prime(2)>cols || x_prime(1)+1>rows || x_prime(2)+1>cols
                continue;
            end
            
            interpolated_img2 = interp2(img2,x_prime(1),x_prime(2), 'cubic') % Interpolating values of img2 at x_prime
            
%             tmp1 = -2 * (img1(x(1), x(2)) - img2(x_prime(1), x_prime(2)));
%             tmp2 = img2(x_prime(1)+1, x_prime(2)) - img2(x_prime(1), x_prime(2));
            tmp1 = -2 * (img1(x(1), x(2)) - interpolated_img2);
            tmp2 = img2(x_prime(1)+1, x_prime(2)) - interpolated_img2;
            tmp3 = x(1)/cols;
            derivative_cost_a11 = (derivative_cost_a11 + (tmp1 * tmp2 * tmp3)); % Summing up the minimised cost function for all pixels fo the image 
        end
    end
    a11_new = A(1,1) - lambda * derivative_cost_a11;
end
