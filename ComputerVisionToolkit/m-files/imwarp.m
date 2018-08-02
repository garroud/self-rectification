function I2 = imwarp(I,H,bb)
%IMWARP  Image warp 
% Apply the projective transformation specified by H to the image I 
% The bounding box is specified with [minx; miny; maxx; maxy];

[x,y] = meshgrid(bb(1):bb(3),bb(2):bb(4));
pp = htx(inv(H),[x(:),y(:)]');
xi=reshape(pp(1,:),size(x,1),[]);
yi=reshape(pp(2,:),size(y,1),[]);
I2=interp2(1:size(I,2),1:size(I,1),double(I),xi,yi,'linear',0);

cast(I2,class(I)); % cast I2 to whatever was I

