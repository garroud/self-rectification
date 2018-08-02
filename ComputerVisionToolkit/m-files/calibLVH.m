function K  = calibLVH( H )
%CALIBLVH Camera calibration from infnity homographies
      
    numV = length(H);
    S = duplication(3);
    
    L = [];                % build linear system
    for i =1:numV
        L = [L; (eye(9)-kron(H{i},H{i}))*S];
    end
    
    [~,~,V] = svd(L);       % solve
    B = reshape(S*V(:,end),3,[]);
     
    [iK,p] = chol(inv(B));       % either B or -B is p.d.
    if p==1 iK = chol(-inv(B));
    end
    
    K = inv(iK); K = K./K(3,3);
end

