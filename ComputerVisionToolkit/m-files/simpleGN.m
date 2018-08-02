function x  = simpleGN(fobj,x0)
%SIMPLEGN  Gauss-Newton method for non-linear LS
    
    % constants
    MaxIterations = 100;
    FunctionTol = 1e-6;
    StepTol = 1e-6;
    
    % initialization
    x = x0(:);
    res = fobj(x)*Inf;
   
    for iter = 1: MaxIterations
        prevres = res;
        [res, Jac] = fobj(x);
        fprintf('\tsimpleGN: residual norm %0.5g \n', norm(res));
              
        if norm(res-prevres)<StepTol || norm(res)<FunctionTol ||...
                ( iter>2 &&  norm(res) > norm(prevres) )
            break; 
        end
        
        dx = - pinv(Jac) * res;
        x = x+dx;
    end
end

% fobj  must retun value and jacobian:  [val, jac] = fobj
