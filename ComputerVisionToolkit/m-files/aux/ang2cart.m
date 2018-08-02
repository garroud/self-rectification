function v = ang2cart( p )
%ANG2CART Angular to cartesian coordinate conversion
    
% give the angular coordinates of a point on the unit sphere
% represented by means of its cartesian coordinates
% supported dimensions: 3 (2 angles) and 4 (3 angles)
    
    if length(p) == 2
        v =  [cos(p(1));
            sin(p(1)) * cos(p(2));
            sin(p(1)) * sin(p(2))] ;
    elseif length(p) == 3
        v =  [cos(p(1));
            sin(p(1)) * cos(p(2));
            sin(p(1)) * sin(p(2)) * cos(p(3));
            sin(p(1)) * sin(p(2)) * sin(p(3))] ;
    else
        error('ang2cart: dimension > 4 not supported')
    end
end
    
