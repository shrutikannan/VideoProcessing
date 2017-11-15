close all;
img1 = double(imread('Fall_trees_0.tif'));
img2 = double(imread('Fall_trees_5.tif'));

% imshow(img1)
% figure
% imshow(img2)

[rows, cols,ch] = size(img1);

A = [1,0;0,1];
b = [0; 0];
lambda = 10^-4;
% a11 = A(1,1);

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
            x_prime = ceil(x_prime);
            if x_prime(1)>rows || x_prime(2)>cols || x_prime(1)+1>rows || x_prime(2)+1>cols
                continue;
            end
            tmp1 = -2 * (img1(x(1), x(2)) - img2(x_prime(1), x_prime(2)));
            tmp2 = img2(x_prime(1)+1, x_prime(2)) - img2(x_prime(1), x_prime(2));
            tmp3 = x(1)/cols;
            derivative_cost_a11 = (derivative_cost_a11 + (tmp1 * tmp2 * tmp3)); % Summing up the minimised cost function for all pixels fo the image 
        end
    end
    a11_new = A(1,1) - lambda * derivative_cost_a11;
end

a12 = -1;
a12_new = A(1,2);
A = [1,0;0,1];
while (a12_new - a12) >= 0.005 % minimising wrt a12
    a12 = a12_new;
    A(1,2) = a12;
    derivative_cost_a12 = 0;
    for row = 1:rows
        for col = 1:cols
            x = [row, col]';
    %         x1 = [x(1) - cols/2]            
            x_prime = A*x + b;
            x_prime = ceil(x_prime);
            if x_prime(1)>rows || x_prime(2)>cols || x_prime(1)+1>rows || x_prime(2)+1>cols
                continue;
            end
            tmp1 = -2 * (img1(x(1), x(2)) - img2(x_prime(1), x_prime(2)));
            tmp2 = img2(x_prime(1)+1, x_prime(2)) - img2(x_prime(1), x_prime(2));
            tmp3 = x(2)/rows;
            derivative_cost_a12 = (derivative_cost_a12 + (tmp1 * tmp2 * tmp3)); % Summing up the minimised cost function for all pixels fo the image 
        end
    end
    a12_new = A(1,2) - lambda * derivative_cost_a12;
end


a21 = -1;
a21_new = A(2,1);
A = [1,0;0,1];
while (a21_new - a21) >= 0.005 % minimising wrt a21
    a21 = a21_new;
    A(2,1) = a21;
    derivative_cost_a21 = 0;
    for row = 1:rows
        for col = 1:cols
            x = [row, col]';
    %         x1 = [x(1) - cols/2]            
            x_prime = A*x + b;
            x_prime = ceil(x_prime);
            if x_prime(1)>rows || x_prime(2)>cols || x_prime(1)+1>rows || x_prime(2)+1>cols
                continue;
            end
            tmp1 = -2 * (img1(x(1), x(2)) - img2(x_prime(1), x_prime(2)));
            tmp2 = img2(x_prime(1)+1, x_prime(2)) - img2(x_prime(1), x_prime(2));
            tmp3 = x(1)/rows;
            derivative_cost_a21 = (derivative_cost_a21 + (tmp1 * tmp2 * tmp3)); % Summing up the minimised cost function for all pixels fo the image 
        end
    end
    a21_new = A(1,2) - lambda * derivative_cost_a21;
end

a22 = 0;
a22_new = A(2,2);
A = [1,0;0,1];
while (a22_new - a22) >= 0.005 % minimising wrt a22
    a22 = a22_new;
    A(2,2) = a22;
    derivative_cost_a22 = 0;
    for row = 1:rows
        for col = 1:cols
            x = [row, col]';
    %         x1 = [x(1) - cols/2]            
            x_prime = A*x + b;
            x_prime = ceil(x_prime);
            if x_prime(1)>rows || x_prime(2)>cols || x_prime(1)+1>rows || x_prime(2)+1>cols
                continue;
            end
            tmp1 = -2 * (img1(x(1), x(2)) - img2(x_prime(1), x_prime(2)));
            tmp2 = img2(x_prime(1)+1, x_prime(2)) - img2(x_prime(1), x_prime(2));
            tmp3 = x(2)/cols;
            derivative_cost_a22 = (derivative_cost_a22 + (tmp1 * tmp2 * tmp3)); % Summing up the minimised cost function for all pixels fo the image 
        end
    end
    a22_new = A(1,2) - lambda * derivative_cost_a22;
end

b1 = 0;
b1_new = b(1);
A = [1,0;0,1];
while (b1_new - b1) >= 0.005 % minimising wrt a22
    b1 = b1_new;
    b(1) = b1;
    derivative_cost_b1 = 0;
    for row = 1:rows
        for col = 1:cols
            x = [row, col]';
    %         x1 = [x(1) - cols/2]            
            x_prime = A*x + b;
            x_prime = ceil(x_prime);
            if x_prime(1)>rows || x_prime(2)>cols || x_prime(1)+1>rows || x_prime(2)+1>cols
                continue;
            end
            tmp1 = -2 * (img1(x(1), x(2)) - img2(x_prime(1), x_prime(2)));
            tmp2 = img2(x_prime(1), x_prime(2)+1) - img2(x_prime(1), x_prime(2));
            tmp3 = 1;
            derivative_cost_b1 = (derivative_cost_b1 + (tmp1 * tmp2 * tmp3)); % Summing up the minimised cost function for all pixels fo the image 
        end
    end
    b1_new = b(1) - lambda * derivative_cost_b1;
end

b2 = 0;
b2_new = b(2);
A = [1,0;0,1];
while (b2_new - b2) >= 0.005 % minimising wrt a22
    b2 = b2_new;
    b(2) = b2;
    derivative_cost_b2 = 0;
    for row = 1:rows
        for col = 1:cols
            x = [row, col]';
    %         x1 = [x(1) - cols/2]            
            x_prime = A*x + b;
            x_prime = ceil(x_prime);
            if x_prime(1)>rows || x_prime(2)>cols || x_prime(1)+1>rows || x_prime(2)+1>cols
                continue;
            end
            tmp1 = -2 * (img1(x(1), x(2)) - img2(x_prime(1), x_prime(2)));
            tmp2 = img2(x_prime(1)+1, x_prime(2)) - img2(x_prime(1), x_prime(2));
            tmp3 = 1;
            derivative_cost_b2 = (derivative_cost_b2 + (tmp1 * tmp2 * tmp3)); % Summing up the minimised cost function for all pixels fo the image 
        end
    end
    b2_new = b(2) - lambda * derivative_cost_b2;
end

a11_new
a12_new
a21_new
a22_new
b1_new
b2_new
A = [a11_new, a12_new; a21_new, a22_new];
b = [1; b2_new];
img3 = zeros(rows, cols);
for row = 1:rows
    for col = 1:cols
        x = [row, col]';
        x_prime = A*x + b;
        if x_prime(1)>rows || x_prime(2)>cols || x_prime(1)+1>rows || x_prime(2)+1>cols
            continue;
        end
        img3(row, col) = img1(ceil(x_prime(1)), ceil(x_prime(2)));
        
        
        
    end
end
imshow()