function [bestmodel, bestinliers] = simpleLMS(x, modelfit, modeldist, p)
%SIMPLELMS - Robust fit with the LMS algorithm
   
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
        % Compute LMS score
        cost = median(sqres);
        
        scale = 1.4826*sqrt(cost)*(1+5/(length(sqres)-p));
        inliers = sqres < (2.5*scale)^2 ;
        
        if cost < mincost
            mincost = cost;
            bestmodel = model;  bestinliers = inliers;
        end
    end
end





