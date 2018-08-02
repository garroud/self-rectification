function X = triang_lin(P, m)
%TRIANG_LIN Triangulation for one point in multiple images
      
    L=[]; % stack equations for every camera
    for j=1:length(P)
        L = [L; skew([m{j};1])*P{j} ]  ;
    end
    [~,~,V] = svd(L);
    X =  V(:,end)./V(end,end);
    
    X = X(1:3,:);
end
    
    
    
    
