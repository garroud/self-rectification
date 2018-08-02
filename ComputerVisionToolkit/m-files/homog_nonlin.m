function  H_out = homog_nonlin(H0, m1, m2)
%HOMOG_NONLIN Non-linear refinement of H
    
    [T1,m1] = precond(m1); [T2,m2] = precond(m2);
    H0 = T2 * H0 /T1;
    
    h = simpleGN(@(x)fobj(x,m1,m2),H0(:));
   
    H_out = reshape(h,3,3);
    
    % apply the inverse scaling
    H_out = T2\H_out * T1;
end

function [res,J] =  fobj(h,m1,m2)
    
    H = reshape(h,3,3);
    res = ones(size(m1,2),1); % value of fobj
    J =[];  % jacobian of fobj
    for i = 1:size(m1,2)
        [r,Jac] = jacobianHomog(h,m1(:,i),m2(:,i));
        res(i) = r;
        J = [J ; Jac];
    end
end

% options = optimoptions('lsqnonlin','Algorithm','levenberg-marquardt',...
%         'SpecifyObjectiveGradient',true,'MaxIterations',100,'StepTolerance',1e-6,...
%         'Display','iter','CheckGradients',false)
%     
%     h = lsqnonlin(@(x) fobj(x,m1,m2),H0(:),[], [],options);