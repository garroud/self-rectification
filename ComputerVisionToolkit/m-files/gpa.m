function  [G,D] = gpa(M,W)
%GPA Generalized Procrustes analysis
    
    m = length(M);
    
    % constants
    MaxIterations = 400;
    FunctionTol = 1e-16;
    StepTol = 1e-16;
    
    G = mat2cell(repmat(eye(4),1,m),4,4*ones(1,m));
    res = Inf;
    
    for iter = 1: MaxIterations
        
        % compute centroid D
        YW = cellfun(@(x,w) x*w, M,W, 'uni',0);
        D = sum(cat(3,YW{:}),3) * diag(1./diag(sum(cat(3,W{:}),3)));
        
        % align each Y{i} onto centroid
        for i = 1:m
            [R,t] = opa(D,M{i},W{i});
            G{i} = [R, t; 0 0 0 1] * G{i};
            M{i} = R*M{i} + t;
        end
        
        prevres=res;
        res_n = cellfun(@(x,w) sum(sum(((x-D)*w).^2)), M,W, 'uni',0);
        res = sum([res_n{:}])/m;
        
         if norm(res-prevres)<StepTol || norm(res)<FunctionTol
             break; end
    end
