function [I1r,I2r, bb1, bb2]  = imrectify(I1,I2,H1,H2,rif)
%IMRECTIFY  Apply rectification to images
     
    bb1 = find_bb(H1,size(I1));
    bb2 = find_bb(H2,size(I2));
    
    if strcmp(rif,'valid')
        % a big image with the greatest bb that contains all
        bb1 = [min(bb1(1),bb2(1)); min(bb1(2),bb2(2)); ...
            max(bb1(3),bb2(3));  max(bb1(4),bb2(4))];
        bb2 = bb1;
        
    elseif strcmp(rif,'crop')
        % the two bb differs horizontally to center the image
     
        % align vertically
        bb1(2)  =  min(bb1(2),bb2(2));
        bb1(4)  =  max(bb1(4),bb2(4));
        bb2(2)  =  bb1(2);
        bb2(4)  =  bb1(4);
        
        % adjust horizontally
        w = max(bb1(3) - bb1(1), bb2(3) - bb2(1)); % max width
        c1 = floor(bb1(3) + bb1(1))/2;
        c2 = floor(bb2(3) + bb2(1))/2;
        bb1(1) = c1 - floor(w/2); bb1(3) = c1 + floor(w/2);
        bb2(1) = c2 - floor(w/2); bb2(3) = c2 + floor(w/2);
        
    elseif strcmp(rif,'orig')
        % keeps the origin in (0,0);  useful only for debug
        bb1 = [0; 0; max(bb1(3),bb2(3)); max(bb1(4),bb2(4))];
        bb2 = bb1;
        
    else
        error('Invalid size option');
    end
    
    % let's do the warp
    I1r = imwarp(single(rgb2gray(I1)),H1, bb1);
    I2r = imwarp(single(rgb2gray(I2)),H2, bb2);
    
end

function bb  = find_bb(H,s)
    % compute the BB of an image after transforming with H
    
    corners = [1,  1,  s(2), s(2);
        1, s(1),  1,  s(1)];
    corners_x = htx(H,corners);
    minx = floor(min(corners_x(1,:)));
    maxx = ceil(max(corners_x(1,:))) ;
    miny = floor(min(corners_x(2,:)));
    maxy = ceil(max(corners_x(2,:))) ;
    bb = [minx; miny; maxx; maxy];
    
end


