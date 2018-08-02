function R = rod(u,theta)
%ROD Rodrigues formula: from axis-angle to rotation matrix 
    
    u = u/norm(u); % make sure it is a unit vector
    
    if theta > eps
        N =  [0 -u(3) u(2)
              u(3) 0 -u(1)
             -u(2) u(1) 0 ];
        R = eye(3) + N*sin(theta) + N^2*(1-cos(theta));
    else
        R = eye(3); % degenerate case
    end
    
end





