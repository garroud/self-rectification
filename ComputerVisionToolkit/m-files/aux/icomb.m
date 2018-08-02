function [ mu, lambda ] = icomb( a, b, c )
%ICOMB Inverse linear combination
% Compute mu and lambd=da s.t. c = mu*a + lambda*b
a=a(:); b=b(:); c=c(:); 

mu    = cross(c,b)'*cross(a,b)/norm(cross(a,b))^2;
lambda = cross(c,a)'*cross(b,a)/norm(cross(a,b))^2;

end

