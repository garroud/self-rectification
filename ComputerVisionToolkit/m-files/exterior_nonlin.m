function [R,t] = exterior_nonlin(R0,t0,q,M,K)
%EXTERIOR_NONLIN Non-linear refinement of exterior orientation
    
    foo = K\[q; ones(1, size(q,2))];
    q = foo(1:2,:);  % NIC
    
    g_out = simpleGN(@(x)fobj(x,M,q),[ieul(R0); t0]);
    
    R = eul(g_out(1:3)); t = g_out(4:6);
end

function [res,J]  = fobj(g,M,q)
    
    % compute residuals
    res = htx([eul(g(1:3)) g(4:6)],M) - q;
    res= res(:);
    
    J =[]; % compute jacobian
    for i = 1:size(M,2)
        [JA, ~]  =   jacobianBA(g(1:3), g(4:6), M(:,i));
        J = [J ; JA];
    end
end


%    options = optimoptions('lsqnonlin','Algorithm','levenberg-marquardt',...
%     'SpecifyObjectiveGradient',true,'MaxIterations',100,'StepTolerance',1e-6,'Display','iter')
%
%     g_out = lsqnonlin(@(x)fobj(x,M,q),[ieul(R0); t0],[], [],options);

