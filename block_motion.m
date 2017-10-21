clc;clear;close all;
img1 = double(imread('missa_1.tif'));
img2 = double(imread('missa_50.tif'));
[rows, cols] = size(img1);
N = 16; % Block size
D = 8; % Search range, precision is 1

min_d = zeros(D,1); %  Stores block start points and d vector for each
b=1; % block number
for m = 1:N:(rows-D+1) % Loop over blocks
    for n = 1:N:(cols-D+1)
        error = zeros(N,1);
        count = 0;
        for d1 = -D:D % displace block by search range
            for d2 = -D:D
                if(m+d1<1 || m+d1+N-1>rows || n+d2<1 || n+d2+N-1>cols) % Boundary condition
                    continue;
                end
                count = count +1;
                if count == 1
                    block_start_m = m+d1;
                    block_start_n = n+d2;
                end
                block1 = img1(m:m+N-1, n:n+N-1);
                block2 = img2(m+d1:m+N-1+d1, n+d2:n+N-1+d2);
                error(m+d1, n+d2) = sum(sum(abs((block1) - (block2)))); % mae %int16
%                 error(m+d1, n+d2) = sum(sum((int16(block1) - int16(block2)).^2)); % mse
            end
        end
        ab1 = find(any(error,2),1,'last'); % Row of last element 
        ab2 = find(any(error,1),1,'last'); % Col of last element
        error(~any(error,2), :) = [];  % Removing rows with 0s
        error(:, ~any(error,1)) = [];  % Removing columns with 0s
        b1 = find(any(error,2),1,'last'); % Row of last element 
        b2 = find(any(error,1),1,'last'); % Col of last element
        [~, tmp2] = min(error(:)); % min val; index
        if n+D >= cols-D+1
           new_centre_x = b1 - D;
           new_centre_y = b2;
        elseif m+D >= rows-D+1
           new_centre_x = b1;
           new_centre_y = b2 - D;
        else
           new_centre_x = b1 - D;
           new_centre_y = b2 - D;
        end

        min_d(b,1) = block_start_m; %m
        min_d(b,2) = block_start_n; %n
        [min_d(b,3), min_d(b,4)] = ind2sub(size(error()), tmp2);
        min_d(b,3) = min_d(b,3) - new_centre_x;
        min_d(b,4)  = min_d(b,4) - new_centre_y;
        min_d(b,5) = ab1;
        min_d(b,6) = ab2;
%         if b > 1
%             d = min_d(b,2) - min_d(b-1,2)
%             tmp1 = min_d(1:b-1, :)
%             tmp3 = min_d(b,:) 
%             tmp2 = repmat(min_d(b-1,:), [d-1,1])
%             min_d = [tmp1; tmp2; tmp3];
%             min_d
%             b = d+1
%         else
            b = b+1;
%         end
    end
end
%%
% 
% figure;
% imshow(img1);
% figure;
% imshow(img2);
% figure;
quiver(min_d(:,1), min_d(:,2), min_d(:,3), min_d(:,4))
camroll(-90)

%%

for m = 1:length(min_d) % Loop over blocks
    for row = min_d(m,1):min_d(m,5)
        for col = min_d(m,2):min_d(m,6)
            mp_error(row,col) = (img1(row,col)) - (img2(row+min_d(m,3), col+min_d(m,4))); %int16
        end
    end
end
mp_error1 = mp_error > 0;
mp_error1 = mp_error1 + 128 ;
imshow(mp_error1)
%%
% 
% 




% start=2
% for i = 2:length(min_d)
%     no_rows = (min_d(i,2) - min_d(i-1,2));
%     www(min_d(i-1,2),:) = min_d(i-1,:);
%     for j = start: start+no_rows
%         www(j,1) = min_d(i-1,1);
%         www(j,2) = www(j-1,2) +1;
%         www(j,3:4) = min_d(i-1,3:4);
%         nxt = j;
%     end
%     if (min_d(i,1) ~= min_d(i-1,1))
%         
%     end
%     www;
%     start = min_d(i,2);
%     
% end
%     



%%
% Loop over block centres m,n, shift by N
    % Loop over each pixel in block, d1,d2, shift between -D to D 
        % block1 is current image current block
        % block2 is block1 shifted by d1,d2
        % Calculate cost and store value, d1, d2
    % d1, d2 associated with the lowest cost is to be found out, store i,j
    % also