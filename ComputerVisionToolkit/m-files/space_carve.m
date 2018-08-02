function V = space_carve(M, Im, PPM)
%SPACE_CARVE Space carving algorithm
      
    V = ones(size(M,2),1); % all opaque
    
    while true % loop
        allVoxelsConsistent =  true;
        
        for j = 1: size(M,2) % for every voxel
            if ~isnan(V(j)) % process only opaque voxels
                
                % S contains the pixels corresponding to voxel j
                S = find_pixels(PPM,M(:,j));
                 
                % get the colors of S
                C = get_colors(Im,S) ;
                
                % set voxel opacity/color
                if is_consistent(C)
                    V(j) = mean(C); % mean color
                else
                    V(j) = NaN; % transparent
                    allVoxelsConsistent =  false;
                end
            end
        end
        if allVoxelsConsistent; break; end  
        % until allVoxelsConsistent
    end      
end  % output: V has color of the voxel or NaN for transparent

% This is a stub for space carving that actually implements shape 
% from silhouettes. In order to implement space carving:
% - the is_consistent function should be rewritten
% - the find_pixels function should take visibility into account

function c = is_consistent(colonna)
    c =  ~any(colonna == 0) ;
end

function S = find_pixels(PPM,M)
     S = zeros(2,size(PPM,2));
    for i = 1: size(PPM,2)
        S(:,i) = htx(PPM{i}, M);
    end 
end

function C = get_colors(Im,x)
    
    C = zeros(size(Im,2),1);
    for i = 1: size(Im,2)
        if   x(1,i)<=0 || x(2,i)<=0 ||  x(1,i)>size(Im{i},2) || x(2,i)>size(Im{i},1)
            C(i) = 0;
        else
            C(i) = Im{i}(ceil(x(2,i)),ceil(x(1,i))); 
        end
    end
end
