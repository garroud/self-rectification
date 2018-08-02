function a = rgb2gray(r,g,b)
%RGB2GRAY Convert RGB image or colormap to grayscale.
%   RGB2GRAY converts RGB images to grayscale by eliminating the
%   hue and saturation information while retaining the
%   luminance.
%
%   I = RGB2GRAY(RGB) converts the truecolor image RGB to the
%   grayscale intensity image I.
%
%   NEWMAP = RGB2GRAY(MAP) returns a grayscale colormap
%   equivalent to MAP.
%
%   Class Support
%   -------------
%   If the input is an RGB image, it can be of class uint8 or
%   double; the output image I is of the same class as the input
%   image. If the input is a colormap, the input and output
%   colormaps are both of class double.
%
%   See also IND2GRAY, NTSC2RGB, RGB2IND, RGB2NTSC.

%   Clay M. Thompson 9-16-92
%   Copyright 1993-1998 The MathWorks, Inc.  All Rights Reserved.
%   $Revision: 5.10 $  $Date: 1997/11/24 15:36:13 $

if nargin==0,
  error('Need input arguments.');
end
threeD = (ndims(r)==3); % Determine if input includes a 3-D array 
 
if nargin==1,
  if threeD,
    rgb = reshape(r(:),size(r,1)*size(r,2),3);
    a = zeros([size(r,1), size(r,2)]);
  else % Colormap
    rgb = r;
    a = zeros(size(r,1),1);
  end

elseif nargin==2,
  error('Wrong number of arguments.');

else
  if (any(size(r)~=size(g)) | any(size(r)~=size(b))),
    error('R, G, and B must all be the same size.')
  end
  rgb = [r(:), g(:), b(:)];
  a = zeros(size(r));
end

T = inv([1.0 0.956 0.621; 1.0 -0.272 -0.647; 1.0 -1.106 1.703]);

if isa(rgb, 'uint8')  
    a = uint8(reshape(double(rgb)*T(1,:)', size(a)));
else
    a = reshape(rgb*T(1,:)', size(a));
end

if ((nargin==1) & (~threeD)),    % rgb2gray(MAP)
    if isa(a, 'uint8')
        a = double(a)/255;
    end
    a = [a,a,a];
end
