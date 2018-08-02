function [Q,R]=qr_p(A)

[Q,R] = qr(A);
D = diag(sign(diag(R)));
Q = Q*D; 
R = D*R;
