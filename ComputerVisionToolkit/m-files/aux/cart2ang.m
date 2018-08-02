function p = cart2ang( v )
%CART2ANG Cartesian to angular coordinate conversion
    
    % give the cartesian coordinates of a point on the unit sphere
    % represented by means of its angular coordinates
    % supported dimensions: 3 (2 angles) and 4 (3 angles)
    
    if norm(v) >0, v=v/norm(v);
    else
        error('cart2ang: cannot convert zero')
    end
    
    if length(v) == 3
        p(1) = acos(v(1));      % aka inclination theta
        p(2) = atan2(v(3),v(2)); % aka azimuth phi
    elseif length(v) == 4
        p(1) = acos(v(1));

        % DA SISTEMARE
        if p(1) ~=0, p(2) = acos(v(2)/sin(p(1)));
        else  p(2) =0;
        end

        %p(2) = acos(v(2)/norm(v(1:3)));
        p(3) = atan2(v(4),v(3));

    else
        error('cart2ang: dimension > 4 not supported')
    end
    p = real(p(:));
end

