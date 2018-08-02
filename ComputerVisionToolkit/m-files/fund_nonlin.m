 function  F_out = fund_nonlin(F0, m1, m2)
%FUND_NONLIN Non-linear refinement of fundamental matrix
    
    [T1,m1] = precond(m1); [T2,m2] = precond(m2);
    F0 = T2'\(F0/T1);
    
    m1 = [m1; ones(1, size(m1,2))]; m2 = [m2; ones(1, size(m2,2))];
    % now m1 and m2 are homogeneous
    
    f_out = simpleGN(@(x)fobj(x,m1,m2),F2par(F0));
    
    % apply the inverse scaling
    F_out = T2' *  par2F(f_out)  * T1;
end

function [res,J] =  fobj(f,m1,m2)
    [F,JF] = par2F(f);  % build F from parameters and return jacobian
    
    res = ones(size(m1,2),1); % value of fobj
    J =[];  % jacobian of fobj
    for i = 1:size(m1,2)
        Fm1 = F*m1(:,i);
        Ftm2 = F.'*m2(:,i);
        s = 1/norm([Fm1(1:2);Ftm2(1:2)]);
        
        res(i) = s * m2(:,i)'*Fm1;
        J = [J ; s * kron(m1(:,i)', m2(:,i)') * JF ];
    end
end

%     options = optimoptions('lsqnonlin','Algorithm','levenberg-marquardt',...
%              'SpecifyObjectiveGradient',true,'MaxIterations',100,'StepTolerance',1e-6,'Display','iter')
%
%     f_out = lsqnonlin(@(x) fobj(x,m1,m2),f_out,[], [],options);
