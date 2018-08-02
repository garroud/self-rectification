function [r,J] = jacobianHF(k,F)
%JACOBIANHF  Jacobian of the Huang-Faugeras residual
       
    K3 = commutation(3,3);
   
    K = [k(1)  0   k(2) ; 0   k(1)  k(3) ;  0   0   1];
    
    E = K'*F*K; EE = E'*E;
    c1 = 2*trace(EE*EE);
    c2 = (trace(EE))^2;
    
    r = c1/c2-1; % objective f.
    
    JH = [ 1/c2, -c1/(c2^2)];
    
    JS = 4* [ EE(:)'* (eye(9)+K3) * kron(eye(3),E');
        trace(EE)*(E(:))'];
    
    JE = K3*kron(eye(3),K'*F') + kron(eye(3),K'*F);
    
    JA =  [ 1, 0, 0 ; 0, 0, 0; 0, 0, 0
        0, 0, 0; 1, 0, 0;  0, 0, 0
        0, 1, 0;  0, 0, 1; 0, 0, 0];
    
    J = JH * JS * JE * JA; % jacobian
end