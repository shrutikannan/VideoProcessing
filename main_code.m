clc; close all; clear
img1 = imread('container_1.tif');
img2 = imread('container_30.tif');
[rows, cols] = size(img1);
N = 16; % Block size
D = 8; % Search range, precision is 1

[min_d1, vector_field1, missa_mae] = block_motion(img1, img2, rows, cols, N, D, 'mae');
savefig('container_mae.fig')
[min_d2, vector_field2, missa_mse] = block_motion(img1, img2, rows, cols, N, D, 'mse');
savefig('container_mse.fig')

[mp_error1, img3] = prediction_error(min_d1, img1, img2, D);
[mp_error2, img4] = prediction_error(min_d2, img1, img2, D);

mse_pe1 = sum(sum(mp_error1.^2));
mse_pe2 = sum(sum(mp_error2.^2));

mae_pe1 = sum(sum(abs(mp_error1)));
mae_pe2 = sum(sum(abs(mp_error2)));

% entropy

%% Plots

s1 = subplot(3,2,1); imshow(imread('container_1.tif')); title('container\_1.tif');
s2 = subplot(3,2,2); imshow(imread('container_30.tif')); title('container\_30.tif');
s3 = subplot(3,2,3) ; title('MAE');
camroll(-90);
s4 = subplot(3,2,4); title('MSE');
camroll(-90);
s5 = subplot(3,2,5); imshow(mp_error1+128); title('Prediction error MAE');
s6 = subplot(3,2,6); imshow(mp_error2+128); title('Prediction error MSE');

c1=openfig('container_mae.fig');
copyobj(allchild(get(c1,'CurrentAxes')),s3);

c2=openfig('container_mse.fig');
copyobj(allchild(get(c2,'CurrentAxes')),s4);


