function [R,t] = exterior_lin(m,M,K)
%EXTERIOR_LIN Exterior orientation with Fiore's algorithm
    
    Q = K\[m; ones(1, size(m,2))]; % homogeneous NIC
    M = [M; ones(1,size(M,2))  ];  % homogeneous
    
    [~, D, V] = svd (M);
    r = sum(diag(D)>max(size(M))*eps(max(D(:)))); % = rank(M)
    Vr = V(:,r+1:end);
    
    % solve null space
    [~, ~, V] = svd(kr(Vr',Q));
    z = V(:,end);
    
    %  fix sign of scale
    z = z * sign(z(1));
    
    [R,t,~] = opa(Q * diag(z), M(1:3,:)); % with scale   
end

% if r~=4; warning('rank is not four'); end