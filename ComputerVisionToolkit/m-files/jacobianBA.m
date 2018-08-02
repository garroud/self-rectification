function [JA, JB]  = jacobianBA(a,t,M)
%JACOBIANBA Jacobian of bundle adjustment
    
    R = eul(a);  % a contains the Euler angles
    W = R*M + t;
    
    Jp=[ 1/W(3), 0, -W(1)/W(3)^2; 0, 1/W(3), -W(2)/W(3)^2];
    JA = Jp * [kron(M(:)',eye(3)) * jacobianEul(a), eye(3)];
    
    JB = Jp * R;
end



