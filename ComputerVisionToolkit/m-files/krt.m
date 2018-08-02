function [K,R,t] = krt (P )
%KRT Internal and external parameters from P

[Q,U] = qr_p(inv(P(1:3, 1:3)));

s = det(Q);
R = s*Q';
t = s*U*P(1:3,4);
K = inv(U./U(3,3));