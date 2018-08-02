function [R,t,s] = opa(D,M,W)
%OPA Orthogonal Procrustes analysis
% Solves the othogonal procrustes problem D=s*(R*M+t*u')
    
    u = ones(size(M,2),1);
   
    if nargin==3  % W is provided
        D = D*W;  M = M*W; u = diag(W);
    end   % otherwise no weights
    
    J = eye(size(M,2))-u*u'/(u'*u);  % centering matrix
    
    [U,S,V] = svd(D*J*M'); % solve for rotation
    R = U*diag([1,1,det(V'*U)])*V';
    
    if nargout==2  % no scale
        s = 1;
    else   % solve for scale  
        s = trace(S) / trace(M*J*M');
        % trace(D*J*M'*R') == trace(S)
    end
    
    t =(D/s -R*M)*u/(u'*u); % solve for translation
end