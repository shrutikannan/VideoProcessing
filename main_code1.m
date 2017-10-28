clc;clear;close all;
img1 = double(imread('Fall_trees_0.tif'));
img2 = double(imread('Fall_trees_0.5.tif'));
[rows, cols] = size(img1);

N = 200; % No of iterations

% Calculating derivatives
[Ix, Iy, It] = compute_derivatives(img1, img2);

% Optical Flow calculations
L = [50, 100,200,400,800]; % List of lambdas
for lambda = 1:length(L) % Looping through lambdas
    [u, v, E] = opt_flow(Ix, Iy, It, L(lambda), rows, cols, N);
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
imshow(EN)
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
imshow(imread('Fall_trees_0.tif'));
figure;
imshow(imread('Fall_trees_0.5.tif'));
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