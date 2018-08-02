function  [R,t] = relative_nonlin(R0, t0, q1, q2, K1, K2 )
%RELATIVE_NONLIN Non-linear refinement of relative orientation
    
    g0(1:3) = ieul(R0);
    g0(4:5) = cart2ang(t0); % t direction is parameterized by 2 angles
    
    q1 = K1\[q1; ones(1, size(q1,2))];
    q2 = K2\[q2; ones(1, size(q2,2))];
    % now q1 and q2 are homogeneous NIC
    
    g = simpleGN(@(x)fobj(x,q1,q2),g0(:));
    
    R = eul(g(1:3));  t = ang2cart(g(4:5));
end

function [res,J] = fobj(g,q1,q2)
    
    a = g(1:3); ia = g(4:5);
    R = eul(a); t = ang2cart(ia);
    
    Jt = [ -sin(ia(1)),                     0
        cos(ia(1))*cos(ia(2)), -sin(ia(1))*sin(ia(2))
        cos(ia(1))*sin(ia(2)),  sin(ia(1))*cos(ia(2)) ];
    
    J =[];
    res=zeros(size(q1,2),1);
    for i = 1:size(q1,2)
        s = 1/norm(cross(R*q1(:,i),q2(:,i)));
        res(i)=t'*cross(R*q1(:,i),q2(:,i))*s;
        J = [J; s*[cross(q2(:,i),t)' * kron(q1(:,i)', ...
            eye(3))*jacobianEul(a),cross(R*q1(:,i),q2(:,i))' * Jt]];
    end
end

%    options = optimoptions('lsqnonlin','Algorithm','levenberg-marquardt',...
%             'SpecifyObjectiveGradient',true,'MaxIterations',100,'StepTolerance',1e-6,'Display','iter')
%
%    g = lsqnonlin(@(x) fobj(x,q1,q2),g0(:),[], [],options);

