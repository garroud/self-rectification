close all
disp(' ');
 
bgnd = 0; % background vakue
N=30; % grid size
datadir = '../cherubino12';

files = findImages(datadir,{'png'});
ppmfiles = findImages(datadir,{'pm'});
imgs = 1:numel(files);

PPM = cell(size(imgs)); Im = cell(size(imgs)); im_bb = cell(size(imgs));
% read data
for i = imgs
    PPM{i} = load([datadir, '/', ppmfiles(i).name]);
    Im{i} = single(rgb2gray(imread([datadir, '/', files(i).name])));
    um = size(Im{i},2); vm = size(Im{i},1);
    im_bb{i} = [ [0;0], [um;0], [um;vm], [0; vm]];
end

% find BB
disp('Computing BB...')
M = triang_poly(im_bb(~cellfun('isempty',im_bb)), PPM(~cellfun('isempty',PPM)));
xmin = min(M(1,:)); xmax = max(M(1,:));
ymin = min(M(2,:)); ymax = max(M(2,:));
zmin = min(M(3,:)); zmax = max(M(3,:));

% initialize grid
[Xgrid,Ygrid,Zgrid] = ...
    meshgrid(linspace(xmin,xmax,N),linspace(ymin,ymax,N),linspace(zmin,zmax,N) );
M_grid = [Xgrid(:)';Ygrid(:)'; Zgrid(:)'];

% carve
disp('Carving...')
V = shape_from_silhouettes(M_grid, Im, PPM, bgnd);

V = space_carve(M_grid, Im, PPM);  V(isnan(V)) = 0; V=logical(V);

disp('Done')
show_surface(M_grid, V , [N, N, N], [0.72  0.68  0.64]);
view(-140,22), camlight headlight
