function [R,t] = icp(D,M)
%ICP Iterative Closet Point algorithm 
    
    MaxIterations = 400;
    FunctionTol = 1e-6;
    StepTol = 1e-6;
    G=eye(4);  res = Inf;
    
    for iter = 1: MaxIterations
        
        prevres = res;
        % compute closest points (in the model) and residuals
        [dist, Dcp] = closestp(M,D);
        res = norm(dist);
        % robust weighting based on distance
        scale =  robstd(dist);
        W = diag( weightfun(dist,scale,'bisquare') ) ;
        
        % compute incremental tranformation
        [R,t] = opa(Dcp,M,W);
        G = [R, t; 0 0 0 1] * G;
        
        % apply transformation that align M onto D
        M = R*M + t;
        
        if norm(res-prevres)<StepTol || norm(res)<FunctionTol
            break; end
    end
    R = G(1:3,1:3); t = G(1:3,4);
end

function  [dist, Dcp] = closestp(D,M)
    %CLOSESTP compute closest points
    
    [dist,I] = min( distmat(D',M'),[],2 );
    Dcp = M(:,I);
end



