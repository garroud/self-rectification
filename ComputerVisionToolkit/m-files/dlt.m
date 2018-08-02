function P = dlt( x, X )
%DLT Direct Linear Transform
    
    X = [X; ones(1, size(X,2))];
    x = [x; ones(1, size(x,2))];
    
    L = [];
    for i = 1: size(X,2)
        L = [L; kron( X(:,i)', skew(x(:,i)) )];
    end
    
    [~,~,V] = svd(L);
    P = reshape(V(:,end),size(x,1),[]);
end

    
