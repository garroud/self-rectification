function C = imchecherboard(n,p)
   
    % Create a rectangular checkerboard of p x p tiles. 
    % The side of every tile is n pixels.
    
C = kron(invhilb(p)<0, ones(n,n));

K = (C>0);
K(:,1:n*p/2)=false;
C(K) = .5;
