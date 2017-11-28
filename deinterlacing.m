folder = 'birds_interl';
directory = dir(strcat(folder, '/*.tif'));
no_frames = numel(directory);

F = make_movie(folder, no_frames);
% movie(F);


h = [1/2, 1, 1/2];
F1(no_frames) = struct('cdata', [], 'colormap', []);
for i = 1:no_frames % Spreading out the rows of the frame
    inter_frame = uint8(get_interlacing(F(i).cdata, i));
    imshow(inter_frame)
    F1(i) = getframe;
end
[rows, cols] = size(inter_frame);
for frame = 1:no_frames
    for row = 1:rows*2
       if (row-1 < 1) || (row+1 > rows)
           continue
       end
       F1(frame).cdata(row,:,:) = F1(frame).cdata(row-1,:,:)*h(1) + ...
           F1(frame).cdata(row,:,:)*h(2) + ...
           F1(frame).cdata(row+1,:,:)*h(3);
    end
end
movie(F1)
