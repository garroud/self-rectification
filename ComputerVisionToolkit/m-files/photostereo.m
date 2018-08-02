function [N, a] = photostereo(B,S)
%PHOTOSTEREO Photometric stereo
    X = B/S;
    a = sqrt(sum(X.^2,2));
    N  = diag(1./a)*X;
end
