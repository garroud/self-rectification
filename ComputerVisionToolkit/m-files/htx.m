function Y = htx( T, X )
%HTX Apply homogeous transform 
%   Apply transformation T in homogeneous coordinates
%   T can be any dimension 
%   T 3x4 is a projection
%   T 3x3 is a transformation of the projective plane
%   T 4x4 is a transformation of the projective space

X = [X; ones(1, size(X,2))]; % make homogeneous

Y = T * X; % apply tranform

Y = Y ./ repmat(Y(end,:),size(Y,1),1); % projective division

Y = Y(1:end-1, :); % remove ones

end
