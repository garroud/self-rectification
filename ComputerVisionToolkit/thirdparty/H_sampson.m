function d = H_sampson(H,m1,m2)
    %H_SAMPSON: Sampson distance for H
    %
    % Returns an approximation of the (unsquared) geometric distance from the
    % 4d joint-space point [m1;m2] to the H manifold. See Torr CVIU 97.
    
    alg = vgg_H_algebraic_distance(H,m1,m2);
    
    n = size(m1,2);
     
    G1 = [ H(1,1) - m2(1,:) * H(3,1) 
           H(1,2) - m2(1,:) * H(3,2) 
          -m1(1,:) * H(3,1) - m1(2,:) * H(3,2) - H(3,3) 
           zeros(1,n) ];
    
    G2 = [ H(2,1) - m2(2,:) * H(3,1) 
          H(2,2) - m2(2,:) * H(3,2) 
          zeros(1,n) 
         -m1(1,:) * H(3,1) - m1(2,:) * H(3,2) - H(3,3) ];
    
    magG1 = sqrt(sum(G1 .* G1));
    magG2 = sqrt(sum(G2 .* G2));
    magG1G2 = sum(G1 .*  G2);
    
    alpha = acos( magG1G2 ./ (magG1 .* magG2) );
    
    D1 = alg(1,:) ./ magG1;
    D2 = alg(2,:) ./ magG2;
    
    d = sqrt ( (D1.*D1 + D2.*D2 - 2 * D1 .* D2 .* cos(alpha)) ./ sin(alpha) ) ;
    d = d(:);
    
end

function d = vgg_H_algebraic_distance(H,m1,m2)
    % For sets of homg points x1 and x2, returns the algebraic distances
    %  d = (p2'_x p2'_y) * p1_w - (p1_x p1_y) * p2'_w
    
    m1 = [m1; ones(1,size(m1,2))];
    m2 = [m2; ones(1,size(m2,2))];
    
    n = size(m1,2);
    Dx = [ m1' .* repmat(m2(3,:)',1,3) , zeros(n,3) , -m1' .* repmat(m2(1,:)',1,3) ];
    Dy = [ zeros(n,3) , m1' .* repmat(m2(3,:)',1,3) , -m1' .* repmat(m2(2,:)',1,3) ];
    h = reshape(H',9,1);
    d = [Dx*h , Dy*h]';
    
end

% Copyright (c) 1995-2005 Visual Geometry Group Department of
% Engineering Science University of Oxford
% http://www.robots.ox.ac.uk/~vgg/ Permission is hereby granted,
% free of charge, to any person obtaining a copy of this software
% and associated documentation files (the "Software"), to deal in
% the Software without restriction, including without limitation
% the rights to use, copy, modify, merge, publish, distribute,
% sublicense, and/or sell copies of the Software, and to permit
% persons to whom the Software is furnished to do so, subject to
% the following conditions:
%
% The above copyright notice and this permission notice shall be
% included in all copies or substantial portions of the Software.
%
% The software is provided "as is", without warranty of any kind,
% express or implied, including but not limited to the warranties
% of merchantability, fitness for a particular purpose and
% noninfringement. In no event shall the authors or copyright
% holders be liable for any claim, damages or other liability,
% whether in an action of contract, tort or otherwise, arising
% from, out of or in connection with the software or the use or
% other dealings in the software.


