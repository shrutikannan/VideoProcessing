function [block1, block2] = check_blocks(block1, block2)
    if any(any(block2,1) == 0) == 1
        x1 = find(any(block2,1) == 0)
        block1(:,x1) = []
        block2(:,x1) = []
    elseif any(any(block1,1) == 0) == 1
        x1 = find(any(block1,1) == 0)
        block1(:,x1) = []
        block2(:,x1) = []
    elseif any(any(block2,2) == 0) == 1
        x1 = find(any(block2,2) == 0)
        block1(x1,:) = []
        block2(x1,:) = []
    elseif any(any(block2,2) == 0) == 1
        x1 = find(any(block2,2) == 0)
        block1(x1,:) = []
        block2(x1,:) = []
    end