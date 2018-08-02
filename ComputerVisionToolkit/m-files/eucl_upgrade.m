function [P1,P2, T] = eucl_upgrade(P1, P2, K1, K2)
    %EUCL_UPGRADE Upgrade projective reconstruction given K
 
    % nornalize canonical pair
    P2 = P2/[P1; [0 0 0 1]]; % P1 = [I,0] is implicit
    
    t = K2\P2(:,4);
    Q = rotvec(t,cross(t,rand(3,1))); % 2nd arg is any vector ~= t
    
    W = Q * ( K2\P2(:,1:3)*K1 );
    [U,D,V] = svd(W(2:3,:)); % svd takes care of scale
    D(1,1)=1; D(2,2)=1;
    R(2:3,:)=U*D*V';
    R(1,:) = cross(R(2,:),R(3,:));
    % upgrade matrix
    v =  (R(1,:)*norm(W(3,:))-W(1,:)) / norm(t); 
    T =  ([P1; [0 0 0 1]]) \ [K1,[0;0;0]; [v , 1]];
    
    % euclidean cameras
    R = Q'* R; 
    P1 = K1*eye(3,4); % result is up to an isometry
    P2 = K2*[R t];  
end

function R = rotvec(x,y)
  % rotazione che porta x su [1 0 0]*norm(x)
  
    R(1,:) = x(:)'/norm(x);
    R(3,:) = cross(R(1,:),y(:)');  R(3,:) = R(3,:)/norm(R(3,:));
    R(2,:) = cross(R(3,:),R(1,:));
end





    % modulo  una permurazione delle righe e' la stessa  soluzione
    % di camera.m
    % rotazione che porta x su [1 0 0]*norm(x)
    % e y in vettore del piano z=0;
    % se y e' ortogonale a x viene mappato su [0 1 0]*norm(b)
