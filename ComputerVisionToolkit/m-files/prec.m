function [PPM, M] = prec(m)
%PREC Sturm-Triggs' projective reconstruction  

    n_imm = length(m);
    for j = 1:n_imm   % preconditioning
        [T{j},m{j}] = precond(m{j});
    end
   
    MaxIterations = 400; 
    FunctionTol = 1e-15;  
    StepTol = 1e-15;
  
    Q = reshape(cell2mat(m(:)),2*length(m),[]);
    tmp=ones(3*n_imm,size(Q,2));
    for i=1:n_imm
        tmp((2*i+i-2):(2*i+i-1),:) = Q((2*(i-1)+1):2*i,:);
    end
    Q=tmp;  % converted to homogeneous
    
    % initialization
    Z=ones(n_imm,size(Q,2));  res = Inf;
    
    for iter = 1: MaxIterations
        
        [U,D,V] = svd(Q.*kron(Z,ones(3,1))); % estimate P and M
        P = U(:,1:4)*D(1:4,1:4); M = V(:,1:4)';
        
        Z = [];  % estimate depth                             
        for i = 1:n_imm
            b = P(3*i-2:3*i,:) * M;
            zi= (kr(eye(size(M,2)), Q(3*i-2:3*i,:)))\b(:);
            Z = [Z; zi'/norm(zi)]; % normalization
        end
        
        prevres = res;
        res = norm(Q.*kron(Z,ones(3,1)) - P*M,'fro');
        if norm(res-prevres)<StepTol || norm(res)<FunctionTol
            break; end
    end   
    M = M./repmat(M(end,:),size(M,1),1);  M = M(1:end-1, :);
 
    for j = 1:n_imm  %  postconditioning
        PPM{j} = T{j} \  P(3*j-2:3*j,:);
    end
end


