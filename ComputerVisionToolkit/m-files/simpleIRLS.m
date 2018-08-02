function [model, inliers] = simpleIRLS(x, modelfit, modeldist)
%SIMPLEIRLS - Robust fit with the IRLS algorithm
    
    MaxIterations = 100;
    FunctionTol = 1e-6;
    StepTol = 1e-6;
    
    % start with OLS fit
    weights =  ones(length(x),1);
    model = modelfit(x, weights);
    obj = Inf;
    
    for  i = 1:MaxIterations
        
        % Evaluate distances between points and model
        res = modeldist(model, x);
        % Estimate scale
        scale = robstd(res);
        % Compute weights
        weights =  weightfun(res,scale);
        % Fit model with weights
        model = modelfit(x, weights);
        
        prevobj= obj;
        obj = sum(weights.*res.^2);
        
        if norm(obj-prevobj)<StepTol || obj<FunctionTol
            break; end
    end
     inliers = abs(res) < (2.5*scale) ;
end





