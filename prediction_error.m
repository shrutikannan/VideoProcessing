function [mp_error, img3] = prediction_error(min_d, img1, img2, D)
[rows, cols] = size(img1);
for m = 1:length(min_d) % Loop over blocks
    for row = min_d(m,1):min_d(m,5)
        for col = min_d(m,2):min_d(m,6)
            mp_error(row,col) = (img2(row,col)) - (img1(row+min_d(m,3), col+min_d(m,4))); %int16 img2-img1 or vice versa??
            img3(row, col) = img1(row+min_d(m,3), col+min_d(m,4));
        end
    end
end
mp_error(min_d(end,5)-1:rows,min_d(end,6)-1:cols) = 0; 
img3(min_d(end,5):rows,min_d(end,6):cols) = img2(min_d(end,5)-D:rows-D,min_d(end,6)-D:cols-D);
