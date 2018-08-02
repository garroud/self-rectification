function d = duplication(n)
%DUPLICATION Returns Magnus and Neudecker's duplication matrix
    
    % duplication(n)
    
    % Author: Thomas P Minka (tpminka@media.mit.edu)
    
    % second method
    a = tril(ones(n));
    i = find(a);
    a(i) = 1:length(i);
    a = a + tril(a,-1)';
    j = a(:);
    
    m = n*(n+1)/2;
    d = zeros(n*n,m);
    for r = 1:n*n
        d(r, j(r)) = 1;
    end
end

