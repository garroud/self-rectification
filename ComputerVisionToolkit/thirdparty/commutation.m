function k = commutation(n, m)
%COMMUTATION Returns Magnus and Neudecker's commutation matrix
    % commutation(n, m) or commutation([n m])
    
    % Author: Thomas P Minka (tpminka@media.mit.edu)
    
    if nargin < 2
        m = n(2);
        n = n(1);
    end
    
    I = eye(n);
    % second method
    k = reshape(kron(I(:), eye(m)), n*m, n*m);
end

