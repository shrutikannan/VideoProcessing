function [min_d, vector_field, fig] = block_motion(img1, img2, rows, cols, N, D, error_fcn)

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
                % if any 1 row or col is fully zeros, ignore that row/col
                % in both blocks while computing error, it is probably the
                % padded array
                if any(any(block2,1) == 0) == 1
                   x1 = find(any(block2,1) == 0);
                   block1(:,x1) = [];
                   block2(:,x1) = [];
                elseif any(any(block1,1) == 0) == 1
                   x1 = find(any(block1,1) == 0);
                   block1(:,x1) = [];
                   block2(:,x1) = [];
                elseif any(any(block2,2) == 0) == 1
                   x1 = find(any(block2,2) == 0);
                   block1(x1,:) = [];
                   block2(x1,:) = [];
                elseif any(any(block2,2) == 0) == 1
                   x1 = find(any(block2,2) == 0);
                   block1(x1,:) = [];
                   block2(x1,:) = [];
                end                
                if strcmp(error_fcn, 'mae')
                    error(m+d1, n+d2) = sum(sum(abs(int16(block1) - int16(block2)))); % mae
                elseif strcmp(error_fcn, 'mse')
                    error(m+d1, n+d2) = sum(sum((int16(block1) - int16(block2)).^2)); % mse
                end
            end
        end
        ab1 = find(any(error,2),1,'last'); % Row of last element of block in image
        ab2 = find(any(error,1),1,'last'); % Col of last element of block in image
        error(~any(error,2), :) = [];  % Removing rows with 0s
        error(:, ~any(error,1)) = [];  % Removing columns with 0s
        b1 = find(any(error,2),1,'last'); % Row of last element in current block
        b2 = find(any(error,1),1,'last'); % Col of last element in current block
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
        min_d(b,1) = block_start_m; % Start row of the block
        min_d(b,2) = block_start_n; % Start col of the block
        [min_d(b,3), min_d(b,4)] = ind2sub(size(error()), tmp2); % Min d values
        min_d(b,3) = min_d(b,3) - new_centre_x;
        min_d(b,4)  = min_d(b,4) - new_centre_y;
        min_d(b,5) = ab1; % End row of block (for looping over blocks later)
        min_d(b,6) = ab2; % End col of block (for looping over blocks later)
        b = b+1;
    end
end

tmp = 1; % temporary variable to increment row number
for i = 2:length(min_d) % Storing more points per block for plotting vector field
    vector_field(tmp,1:4) = min_d(i,1:4);
    vector_field(tmp+1,1) = min_d(i,1) + 4;
    vector_field(tmp+1,2) = min_d(i,2);
    vector_field(tmp+2,1) = min_d(i,1);
    vector_field(tmp+2,2) = min_d(i,2) + 4;
    vector_field(tmp+3,1:2) = min_d(i,1:2) + 4;
    vector_field(tmp+1:tmp+3,3:4) = repmat(min_d(i,3:4),3,1);
    tmp = tmp+4;
end

fig = figure;
quiver(vector_field(:,1), vector_field(:,2), vector_field(:,3), vector_field(:,4),0);
camroll(-90);
