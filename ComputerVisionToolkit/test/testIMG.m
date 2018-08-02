close all

disp(' ');
%--------------------------------------------------------------------------
% rectification

P1 =  load('../cherubino12/IMG_0011.pm');
P2 =  load('../cherubino12/IMG_0012.pm');

I1 = imread('../cherubino12/IMG_0011.JPG');
I2 = imread('../cherubino12/IMG_0012.JPG');

[H1,H2,Pn1,Pn2] = rectifyP(P1,P2);

[I1r,I2r, bb1, bb2] = imrectify(I1,I2,H1,H2,'valid');

%xshift =  bb1(1)  - bb2(1)

% fix the MPP after centering
Pn1 = [1 0 -bb1(1);  0 1 -bb1(2); 0 0 1] *Pn1;
Pn2 = [1 0 -bb2(1);  0 1 -bb2(2); 0 0 1] *Pn2;

% The F matrix induced by Pn1,Pn2 shoud be skew([1 0 0])
fprintf('Rectification algebraic error:\t\t %0.5g \n',  ...
  norm ( abs(fund(Pn1,Pn2)/norm(fund(Pn1,Pn2))) - abs(skew([ 1 0 0]))) );

figure, imshow(I1r,[],'InitialMagnification','fit');
figure, imshow(I2r,[],'InitialMagnification','fit');


% TEST points for cherubino12
x1 = [1071      640         646
    190         573        1110];

x2 = [ 1003         552         547
    265         627        1176];

% show points on original left image
figure, imshow(I1,[],'InitialMagnification','fit');
hold on
plot(x1(1,:), x1(2,:),'ys','MarkerSize',16);

% compute 3D points from original pair
X_est=triang_lin_batch({P1, P2}, {x1,x2});

% project 3D points with the new PPM and show them on left...
m1 = htx(Pn1,X_est(:,:));
figure(1), hold on
plot(m1(1,:), m1(2,:),'ys','MarkerSize',16);
%... and right rectified images
m2 = htx(Pn2,X_est(:,:));
figure(2), hold on
plot(m2(1,:), m2(2,:),'ys','MarkerSize',16);

% is they are the same this means that the rectified PPMs are
% consistent with the rectified images

%%
disp('Computing stereo...')
imo=imstereo_ncc(I2r,I1r,[260,460],[7,7]);
figure,imshow(imo,[],'InitialMagnification','fit');
title('Disparita NCC');
colorbar
disp('Done')

%%

[ims,imd] = imrds(400,30);
figure,imshow(ims,[]); figure,imshow(imd,[]);

imo=imstereo_ssd(ims,imd,[0,50],[5,5]);
figure,imshow(imo,[]);
title('Disparita SSD');
colorbar

imo=imstereo_ncc(ims,imd,[0,50],[5,5]);
figure,imshow(imo,[]);
title('Disparita  NCC');
colorbar

%%

I=(imchecherboard(50,8));
angolo= .15;
H = [cos(angolo),sin(angolo),100;
    -sin(angolo),cos(angolo),100;
    0,0,1];  % matrice affine

% opzione same:
bb  = [1;1;size(I,1);size(I,2)];

% opzione valid
corners = [1, 1, size(I,2), size(I,2);
    1, size(I,1), 1, size(I,1)];
corners_x = htx(H,corners);
minx = floor(min(corners_x(1,:)));
maxx = ceil(max(corners_x(1,:))) ;
miny = floor(min(corners_x(2,:)));
maxy = ceil(max(corners_x(2,:))) ;
bb = [minx; miny; maxx; maxy];

I2= imwarp(double(I),H, bb );

figure, imshow(I2, []);
title('Warping');


%% HS
I=(imchecherboard(50,8));
figure,imshow(I,[]);

C=imhs(I,5);
figure,imshow(C,[]); hold on;

