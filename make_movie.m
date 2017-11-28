function [F] = make_movie(folder, no_frames)
    F(no_frames) = struct('cdata', [], 'colormap', []);
    for i = 1:no_frames
        filename = strcat(folder, '/', folder, '_' , int2str(i), '.tif');
        frame = imread(filename);
        imshow(frame);
        F(i) = getframe;
    end
