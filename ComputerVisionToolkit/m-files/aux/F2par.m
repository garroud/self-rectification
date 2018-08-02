function f = F2par(F)
%F2PAR Fundamental matrix parametrization
   
    f = zeros(7,1);
    F = F./norm(F(1:2,1:2),'fro');
 
    f(1:3) = cart2ang(vec(F(1:2,1:2)));
    [f(4), f(5) ] = icomb(F(1,:), F(2,:), F(3,:)) ;
    [f(6), f(7) ] = icomb(F(:,1), F(:,2), F(:,3)) ;

end

