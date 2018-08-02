function [T1,T2,Pn1,Pn2] = rectifyP(P1,P2)
% RECTIFYP Epipolar rectification (calibrated)
    
    % factorise old PPM
    [K1,R1,t1] = krt(P1); [K2,R2,t2] = krt(P2);
    
    % optical centers (unchanged)
    c1 = - R1'*t1; c2 = - R2'*t2;
    
    % new x axis is the baseline
    v1 = (c2-c1) * sign(cross(R1(2,:),R1(3,:))*c2);

    % new y axes (orthogonal to old z and new x)
    v2 = cross(R1(3,:)',v1);
    % new z axes (no choice)
    v3 = cross(v1,v2);
    
    % rotation matrix (normalize rows)
    R = [v1(:)/norm(v1), v2(:)/norm(v2), v3(:)/norm(v3)]';
    
    % new intrinsic (arbitrary)
    Kn1 = K2; Kn1(1,2)=0; Kn2 = Kn1;
    
    % new projection matrices
    Pn1 = Kn1*[R -R*c1];  Pn2 = Kn2*[R -R*c2];
    
    % rectifying image transformation
    T1 = Pn1(1:3,1:3)/(P1(1:3,1:3)); T2 = Pn2(1:3,1:3)/(P2(1:3,1:3));
    
    
    
    
    
