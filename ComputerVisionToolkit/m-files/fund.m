function F = fund(P1,P2)
%FUND Computes fundamental matrix from camera matrices

Q = P2(:,1:3)/P1(:,1:3);
e2 = P2(:,4) - Q*P1(:,4);

F=skew(e2)*Q;



