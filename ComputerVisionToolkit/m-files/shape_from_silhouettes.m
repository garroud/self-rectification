function V = shape_from_silhouettes(M, Im, PPM, bgnd)
%SHAPE_FROM_SILHOUETTES Shape from silhouettes
    
    V = true(size(M,2),1); % all opaque
    S = zeros(2,size(PPM,2));
    
    for j = 1: size(M,2) % for every voxel
        for i = 1: size(PPM,2) % for every image
            S(:,i) = htx(PPM{i}, M(:,j));
        end
        % S contains pixels corresponding to voxel j
        C = get_colors(Im, S, bgnd);  % get the colors of S
        V(j) = ~any(C == bgnd);  % set opacity
    end
end  % output: V is true for opaque, false for transparent

function C = get_colors(Im,x,bgnd)
    % return the color of pixels x
    C = zeros(size(Im,2),1);
    for i = 1: size(Im,2)
        if   x(1,i)<=0 || x(2,i)<=0 ||...
                x(1,i)>size(Im{i},2) || x(2,i)>size(Im{i},1)
            C(i) = bgnd;
        else
            C(i) = Im{i}(ceil(x(2,i)),ceil(x(1,i)));
            % would be better to interpolate
        end
    end
end
