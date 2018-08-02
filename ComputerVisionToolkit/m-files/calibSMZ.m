function [P,K] = calibSMZ(m,M)
%CALIBSMZ Camera calibration from 2D-2D correspondences
    
    numV = length(m);
    S = duplication(3);   

    L = [];                % build linear system
    for i =1:numV
        H{i} = dlt(m{i},M);
        L=[L
          (kron(H{i}(:,2)',H{i}(:,1)'))*S;
          (kron(H{i}(:,1)',H{i}(:,1)')-kron(H{i}(:,2)',H{i}(:,2)'))*S];
    end
    
    [~,~,V] = svd(L);       % solve
    B = reshape(S*V(:,end),3,[]);
    
    [iK,p] = chol(B);       % either B or -B is p.d.
    if p==1 iK = chol(-B);
    end
    
    K = inv(iK); K = K./K(3,3);
    
    for i =1:numV
        A =  iK * H{i};  
        A = sign(det(A))*A/norm(A(:,1:2));    
        R = [A(:,1:2) , cross(A(:,2), A(:,1))];
       
        %  project onto SO(3)
        [U,~,V] = svd(R);
        U*diag([1,1,det(V'*U)])*V';
        
        P{i} =  K * [R,A(:,3)];
    end
end








