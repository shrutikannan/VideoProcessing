%%
clc;clear;close all;
img1 = double(imread('Fall_trees_0.tif'));
img2 = double(imread('Fall_trees_0.5.tif'));
[rows, cols] = size(img1);

[Ix, Iy] = deal(zeros(rows, cols), zeros(rows, cols));
N = 100; % No of iterations

for i = 2:cols-1
    Ix(:,i) = img2(:,i) - img2(:,i-1);
end
for i = 2:rows-1
    Iy(i,:) = img2(i,:) - img2(i-1,:);
end
It = img2 - img1;

%%
L = [50, 100,200,400,800]; % List of lambdas
u = zeros(rows, cols, N);
v = zeros(rows, cols, N);
for lambda = 1:length(L)
    for n = 2:N
        for i = 2:rows-1 % Looping through each pixel of the image
            for j = 2:cols-1
                u_n(i,j) =  0.25 * (u(i-1, j, n) + u(i+1, j, n-1) + u(i, j-1, n) + u(i, j+1, n-1));
                v_n(i,j) =  0.25 * (v(i-1, j, n) + v(i+1, j, n-1) + v(i, j-1, n) + v(i, j+1, n-1));

                tmp = (Ix(i,j)*u_n(i,j) + Iy(i,j)*v_n(i,j) + It(i,j)) / (8*L(lambda) + Ix(i,j)^2 + Iy(i,j)^2);
                u(i,j,n) = u_n(i,j) - tmp * Ix(i,j);
                v(i,j,n) = v_n(i,j) - tmp * Iy(i,j);

                tmp1 = (Ix(i,j)*u(i,j,n) + Iy(i,j)*v(i,j,n) + It(i,j)).^2;
                tmp2 = L(lambda) * ((u(i,j,n) - u(i-1,j,n)).^2 + (u(i,j,n) - u(i,j-1,n)).^2 + ...
                                 (v(i,j,n) - v(i-1,j,n)).^2 + (v(i,j,n) - v(i,j-1,n)).^2);
                E(n,1) = sum(sum(tmp1 + tmp2));
            end
        end
    end
    mse_u(lambda) = sum(sum())
end
% img1 = padarray(img1,[1  1],0,'both'); % Pad with 1x1 array of 0s to both sides
% img2 = padarray(img2,[1  1],0,'both');
% un = padarray (zeros(rows, cols), [1 1], 0);
% vn = padarray (zeros(rows, cols), [1 1], 0);
%         u_n(i, j) =  0.25 * (un(i-1, j) + un_1(i+1, j) + un(i, j-1) + un_1(i, j+1));
%         v_n(i, j) = 0.25  * (vn(i-1, j) + vn_1(i+1, j) + vn(i, j-1) + vn_1(i, j+1));
%%
figure;
imshow(imread('Fall_trees_0.tif'));
figure;
imshow(imread('Fall_trees_0.5.tif'));
figure;
[t,w] = meshgrid(1:rows, 1:cols);
quiver(w,t,u(:,:,N)', v(:,:,N)');
camroll(180)
set(gca,'Xdir','reverse')