function [w, rho] = weightfun(r,s,wfun)
    % WEIGHTFUN:  M-estimators weight functions
    
    % r are the residuals
    % s is a robust estimte of std dev (see ROBSTD).
    % wfun is the name oif the weight function. Default = 'bisquare'
    
    if nargin < 3
        wfun = 'bisquare';
    end
    
    % Convert name of weight function to a handle to a local function,
    % and get the default value of the tuning parameter.
    % Default tuning constants give coefficient estimates that are
    % approximately 95% as statistically efficient as the ordinary
    % least-squares estimates, provided the response has a normal
    % distribution with no outliers.
    
    switch(wfun)
        case 'andrews'
            wfun = @andrews;
            t = 1.339;
        case 'bisquare'
            wfun = @bisquare;
            t = 4.685;
        case 'cauchy'
            wfun = @cauchy;
            t= 2.385;
        case 'fair'
            wfun = @fair;
            t = 1.400;
        case 'huber'
            wfun = @huber;
            t = 1.345;
        case 'logistic'
            wfun = @logistic;
            t = 1.205;
        case 'ols'
            wfun = @ols;
            t = 1;
        case 'talwar'
            wfun = @talwar;
            t = 2.795;
        case 'welsch'
            wfun = @welsch;
            t = 2.985;
        otherwise
            error('Unknown method.')
    end
    
    [w,rho] = wfun(r./(t*s));
    
    % --------- weight functions
    
function [w,rho] = bisquare(r)
    w = (abs(r)<1) .* (1 - r.^2).^2;
    rho =  1/6 * ones(size(w));
    rho(abs(r)<=1)  =  1/6*(1-(1-r(abs(r)<=1).^2).^3);
    
function [w,rho] = cauchy(r)
    w = 1 ./ (1 + r.^2);
    rho = .5*log(1+r.^2);
   
function [w,rho] = huber(r)
    w = 1 ./ max(1, abs(r));
    rho =  abs(r) - .5;
    rho(abs(r)<=1) = .5 * r(abs(r)<=1).^2; 
    
function [w,rho] = ols(r)
    w = ones(size(r));
    rho = r.^2;
    
function w = talwar(r)
    w = 1 * (abs(r)<1);
    
function w = welsch(r)
    w = exp(-(r.^2));
    
function w = andrews(r)
    r = max(sqrt(eps(class(r))), abs(r));
    w = (abs(r)<pi) .* sin(r) ./ r;
    
function w = logistic(r)
    r = max(sqrt(eps(class(r))), abs(r));
    w = tanh(r) ./ r;
    
function w = fair(r)
    w = 1 ./ (1 + abs(r));
    
    
    
