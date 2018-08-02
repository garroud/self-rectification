function [I1,I2] = imrds(n,d)
%IMRDS Create a RDS of dimension n x n with disparity d    
 
I1 = rand(n);
I2 = I1;
p= ceil(n/3);
I2(p:2*p, p+d:2*p+d) = I1(p:2*p, p:2*p);


