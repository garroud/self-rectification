function  a  = ieul(R)
    %IEUL Euler angles from a rotation matrix
    
    % angles are in the range [-pi, pi]
   
    a=zeros(3,1);
    a(1) =  atan2(R(3,2),R(3,3)); % omega 
    a(2) = atan2(-R(3,1),sqrt(R(3,2)^2+R(3,3)^2)); % phi
    a(3) = atan2(R(2,1),R(1,1)); % kappa
end





