%%
clc;clear;close all;
img1 = double(imread('missa_1.tif'));
img2 = double(imread('missa_50.tif'));
[rows, cols] = size(img1);

[Ix, Iy] = deal(zeros(rows, cols), zeros(rows, cols));
N = 200; % No of iterations

%% Calculating derivatives
for i = 2:cols-1
    Ix(:,i) = img2(:,i) - img2(:,i-1);
end
for i = 2:rows-1
    Iy(i,:) = img2(i,:) - img2(i-1,:);
end
It = img2 - img1;

%% Optical Flow calculations

L = [50, 100,200,400,800]; % List of lambdas
u = zeros(rows, cols, N); % Initialising u to 0
v = zeros(rows, cols, N); % Initialising v to 0
for lambda = 1:length(L) % Looping through lambdas
    for n = 2:N % Iterations
        for i = 2:rows-1 % Looping through each pixel of the image
            for j = 2:cols-1
                u_n(i,j) =  0.25 * (u(i-1, j, n) + u(i+1, j, n-1) + u(i, j-1, n) + u(i, j+1, n-1)); %  Gauss-Siedel update
                v_n(i,j) =  0.25 * (v(i-1, j, n) + v(i+1, j, n-1) + v(i, j-1, n) + v(i, j+1, n-1));

                tmp = (Ix(i,j)*u_n(i,j) + Iy(i,j)*v_n(i,j) + It(i,j)) / (8*L(lambda) + Ix(i,j)^2 + Iy(i,j)^2); % Update equation for HS
                u(i,j,n) = u_n(i,j) - tmp * Ix(i,j);
                v(i,j,n) = v_n(i,j) - tmp * Iy(i,j);

                tmp1 = (Ix(i,j)*u(i,j,n) + Iy(i,j)*v(i,j,n) + It(i,j)).^2; % Cost function calculation
                tmp2 = L(lambda) * ((u(i,j,n) - u(i-1,j,n)).^2 + (u(i,j,n) - u(i,j-1,n)).^2 + ...
                                 (v(i,j,n) - v(i-1,j,n)).^2 + (v(i,j,n) - v(i,j-1,n)).^2);
                E(n,1) = E(n,1) + sum(sum(tmp1 + tmp2));
            end
        end
%         En(:,:,n) = img2 - lin_sep_interpolation(img1, u(:,:,n), v(:,:,n));
    end
    mse_u(lambda) = sum(sum((u(:,:,N) - 0.5).^2)); % MSE for current lambda value
    mse_v(lambda) = sum(sum((v(:,:,N) - 0.5).^2));
end

[min_u, ind_min_u] = min(mse_u); % Min MSE for u
[min_v, ind_min_v] = min(mse_v); % Min MSE for v
optimal_lambda = L(ind_min_u); % Lambda which gave minimum MSE

E0 = img2 - img1; % Initial motion compensated
% EN = zeros(rows, cols);
I_tilda = lin_sep_interpolation(img1, u, v);
EN = img2 - I_tilda;
% for row = 1:rows
%     for col = 1:cols
%         I_tilda(row,col) = lin_sep_interpolation(img1, row, col, u(row,col,N), v(row,col,N));
%         EN(row,col) = img2(row,col) - I_tilda(row,col); %int16
%     end
% end

%% Plots

figure(1);
subplot(2,2,1), subimage(E0);
title('E0');
subplot(2,2,2), subimage(EN);
title('EN');
subplot(2,2,3), plot(1:N, E);
title('Cost function');
% subplot(2,2,4), plot(1:N, mse_u, 1:N, mse_v);
% title('MSE');


figure;
imshow(imread('missa_1.tif'));
figure;
imshow(imread('missa_50.tif'));
figure;
[t,w] = meshgrid(1:rows, 1:cols);
quiver(w,t,u(:,:,1)', v(:,:,1)');
figure;
quiver(w,t,u(:,:,10)', v(:,:,10)');
figure;
quiver(w,t,u(:,:,50)', v(:,:,50)');
figure;
quiver(w,t,u(:,:,200)', v(:,:,200)');
camroll(180)
set(gca,'Xdir','reverse')



%%
% img1 = padarray(img1,[1  1],0,'both'); % Pad with 1x1 array of 0s to both sides
% img2 = padarray(img2,[1  1],0,'both');
% un = padarray (zeros(rows, cols), [1 1], 0);
% vn = padarray (zeros(rows, cols), [1 1], 0);
%         u_n(i, j) =  0.25 * (un(i-1, j) + un_1(i+1, j) + un(i, j-1) + un_1(i, j+1));
%         v_n(i, j) = 0.25  * (vn(i-1, j) + vn_1(i+1, j) + vn(i, j-1) + vn_1(i, j+1));