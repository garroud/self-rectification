function M = triang_nonlin(M0, P, m)
%TRIANG_NONLIN Non-linear refinement of triangulation
    
    M = simpleGN(@(x)fobj(x,P,m),M0);
    
end

function [res,J] = fobj(M,P,m)
    J=[];  res=[];
    for j=1:length(P)
        res= [res; htx(P{j},M) - m{j}];
        
        W = P{j}*[M;1]; %transf. before division
        Jp=[1/W(3), 0, -W(1)/W(3)^2; 0, 1/W(3), -W(2)/W(3)^2];
        J=[J ; Jp* P{j}(1:3,1:3)];
    end
end

%    options = optimoptions('lsqnonlin','Algorithm','levenberg-marquardt',...
%              'SpecifyObjectiveGradient',true,'MaxIterations',100,'StepTolerance',1e-6,'Display','iter')
%
%    M = lsqnonlin(@(x)fobj(x,P,m),M0,[], [],options);
%


