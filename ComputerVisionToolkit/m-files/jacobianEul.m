function J  = jacobianEul(a)
    %JACOBIANEUL Jacobian of a rotation given by Euler angles
    
    % a contains the Euler anlges omega, phi, kappa 
      
    J_th = @(u,x) skew(u) * (eye(3)* cos(x) + skew(u)* sin(x)) ;
    
    R1 =  [1     0         0
           0 cos(a(1))  -sin(a(1))
           0 sin(a(1))  cos(a(1))]; % omega
    
    R2 = [cos(a(2))  0 sin(a(2))
          0          1       0
        -sin(a(2)) 0  cos(a(2))]; % phi
    
    R3 = [cos(a(3)) -sin(a(3))  0
         sin(a(3))   cos(a(3))  0
         0            0         1];  % kappa
    
    % derivative wrt omega
    J_1 = R3 * R2* J_th([1,0,0], a(1));
    
    % derivative wrt phi
    J_2 = R3 * J_th([0,1,0],a(2)) * R1 ;
    
    % derivative wrt kappa
    J_3 = J_th([0,0,1], a(3)) * R2 * R1;
    
    J = [J_1(:), J_2(:), J_3(:)] ;
    
    
    
