addpath('vlfeat-0.9.21/toolbox/');
addpath('ComputerVisionToolkit/m-files');
%Scipt run the rectification.
master_image_name = 'test_data/image0_s.png';
slave_image_name = 'test_data/image1_s.png';

%image size to do recitification, you should be careful to make the
%reshaped image consistent with its own height and width
calib_height = 960;
calib_width  = 720;

%Threshold to calculate alignment ratio in RANSAC;
threshold = 1;

%Deal with images
master_image = imread(master_image_name);
slave_image  = imread(slave_image_name);

if size(master_image,3) == 1
    master_image = repmat(master_image,[1,1,3]);
    slave_image  = repmat(slave_image, [1,1,3]);
end
master_image = imresize(master_image,[calib_height,calib_width]);
slave_image = imresize(slave_image, [calib_height, calib_width]);

%Feature matching with SIFT, the coordinate is ordered in x,y
fprintf('process SIFT matching\n');
[ml,mr,~]= sift_match_pair(master_image,slave_image,'F');

%number of trials and number of points picked for RANSAC
num_trials = 200;
point_pick = 20;

fprintf('Begin Rectify\n');
tic;
[H2,score] = get_singleH(ml, mr, num_trials, point_pick,calib_height, calib_width, threshold);
toc;

px1r = get_align_rate(H2, ml, mr, 1);
px2r = get_align_rate(H2, ml, mr, 2);
px3r = get_align_rate(H2, ml, mr, 3);

NVD_error = cal_NVD(H2, double(calib_height), double(calib_width));
fprintf('recification PAP: 1px: %f, 2px: %f, 3px: %f, NVD error: %f \n', px1r, px2r, px3r, NVD_error);

%%%Display Images
H1 = eye(3);
[master_image_t, slave_image_t ,~] = imrectify(master_image, slave_image, H1, H2, 'crop');  
figure;imshow(master_image_t,[]);
figure;imshow(slave_image_t, []);
imwrite(uint8(master_image_t), 'rec_img0.png');
imwrite(uint8(slave_image_t), 'rec_img1.png');



