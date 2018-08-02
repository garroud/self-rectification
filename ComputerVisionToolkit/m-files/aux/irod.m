function [u,theta] = irod(R)
%IROD Inverse Rodrigues formula: from rotation matrix to axis-angle
    
    theta = acos((trace(R)-1)/2);
    u0 = [R(3,2)-R(2,3); R(1,3)-R(3,1); R(2,1)-R(1,2)];
    u = u0/norm(u0);
end
