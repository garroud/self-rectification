function [bestmodel, bestinliers] = simpleMSAC(x, modelfit, modeldist, p, t)
 %SIMPLEMSAC - Robust fit with the MSAC algorithm   
 
    n = size(x,2);
    alpha = 0.99; % Desired probability of success
    f = 0.5 ; % Pessimistic estimate of inliers fraction
    
    MaxIterations  = max( ceil(log(1-alpha)/log(1-f^p)), 100);
    mincost =  Inf;
   
    for  i = 1:MaxIterations
        
        % Generate s random indicies in the range 1..npts
        mss = randsample(n, p);
        
        % Fit model to this minimal sample set.
        model = modelfit(x(:,mss));
        
        % Evaluate distances between points and model
        sqres = modeldist(model, x).^2;
        inliers = sqres < (t^2);
        
        % Compute MSAc score
        cost = (sum(sqres(inliers)) + (n -sum(inliers)) * t^2);
        
        if cost < mincost    
            mincost = cost; 
            bestinliers = inliers; bestmodel = model;
        end
    end
end

