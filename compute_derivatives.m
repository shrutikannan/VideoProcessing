function [Ix, Iy, It] = compute_derivatives(img1, img2)
    [rows, cols] = size(img1);
    Ix = zeros(rows, cols);
    Iy = zeros(rows, cols);

    Ix = img2(:,2:cols) - img2(:,1:cols-1);
    Ix(:,cols) = img2(:, cols);
    Iy = img2(2:rows,:) - img2(1:rows-1,:);
    Iy(rows,:) = img2(rows,:);
    It = img2 - img1;