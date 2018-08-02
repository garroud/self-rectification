function F = fund_lin(m1,m2,w)
%FUND_LIN  Fundamental matrix with 8-points algorithm
    
    if nargin <3, w = ones(size(m1,2),1); end % weights
 
    % pre-conditioning
    [T1,m1] = precond(m1); [T2,m2] = precond(m2);
    
    m1 = [m1;ones(1,size(m1,2))]; m2 = [m2;ones(1,size(m2,2))];
    % now m1 and m2 are homogeneous
    
    F = eight_points(m1, m2, w);
    
    % apply the inverse scaling
    F = T2' * F * T1;
    
    % enforce singularity of  F
    [U,D,V] = svd(F);
    D(3,3) = 0; F = U *D*V';
    
end













