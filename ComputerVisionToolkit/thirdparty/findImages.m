
function files = findImages(path,formats)
%
%   Returns images from current or specified path (see dir).
%
%       path - directory to search (default: '.')
%       formats - cell array of desired extensions (default:
%       all image formats supported from matlab)
% 
%   Author: Riccardo Gherardi

error(nargchk(0,2,nargin))
if nargin < 1; path = '.'; end
if nargin < 2
    
    formats = imformats();
    formats = cat(2,formats.ext);
    
end

files = dir(path);
files = files(~cat(1,files.isdir));

exts = regexp({files.name},'[^.]*$','match');
exts = cat(1,exts{:});


files = files(ismember(lower(exts),formats));
