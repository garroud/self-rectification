function S = skew( u )
% SKEW  Returns the skew-symmetric matrix S s.t. skew(u,v) = S*v
% Generalized to arbitrary dimensions

u = u(:);
n = length(u);

if n == 3
    
    S=[   0    -u(3)  u(2)
        u(3)    0   -u(1)     
        -u(2)  u(1)   0   ];
    
else
    
    
    S =  [];
    for i=1:n
        S = [S;
            zeros(n-i, i-1), -u(i+1:end), u(i) * eye(n-i)];
    end
    
    % % reorder rows and change sign s.t. S is skew-symmetric (if n==3)
    % if n == 3
    %     S = [0 0 1; 0 -1 0; 1 0 0] * S;
    % end
    
    
end

% if n==3 S is the skew-symmetric matrix [u]_x up to:
% swapping 1st and 3rd rows and  changing the sign of the 2nd row
% S=[   0    -x(3)  x(2)
%      x(3)    0   -x(1)
%     -x(2)  x(1)   0   ];
