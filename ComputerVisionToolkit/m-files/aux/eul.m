function R = eul(a)
    %EUL Rotation matrix from Euler angles
    
    % a contains the Euler anlges omega, phi, kappa
    
    R = [cos(a(3)) -sin(a(3)) 0
        sin(a(3)) cos(a(3)), 0
        0   0           1] * ...
        [cos(a(2)) 0 sin(a(2))
        0        1       0
        -sin(a(2)) 0  cos(a(2))] * ...
        [1   0         0
        0 cos(a(1))  -sin(a(1))
        0 sin(a(1))  cos(a(1))];
    
end

