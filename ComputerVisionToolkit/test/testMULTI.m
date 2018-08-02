close all

n_imm=10; % # of frames
n_pts= 15;
density = .8; %holes

M = 1.2*(rand(3, n_pts)-.5);  % 3D points

K = [500 0 200
    0  500 200
    0    0   1]; % internal parameters


plot3(M(1,:), M(2,:), M(3,:), 'o'); hold on

% ground truth
Ggt=cell(1,n_imm);
m=cell(1,n_imm);

for i = 1:n_imm
    
    cop = 5 * (rand(3,1) -.5);
    cop(3) = 10 + 2*(rand-.5);
    plot3(cop(1,:),cop(2,:),cop(3,:),'+')
    
    Ggt{i} = camera(  cop, rand(3,1) -.5, [0;1;0]);
    Pgt{i}  = K*Ggt{i};
    Ggt{i} = [Ggt{i}; 0 0 0 1];
    Cgt{i} = - Ggt{i}(1:3,1:3)' * Ggt{i}(1:3,4); %centri
    m{i}  = htx(Pgt{i},M);
    
end


disp(' ');
%-------------------------------------------------------------------------
% SMZ calibration

% 100 planar points on a grid
[Xgrid,Ygrid] = meshgrid(-0.5:0.1:0.4);
M_grid = [Xgrid(:)';Ygrid(:)'; zeros(1,size(Xgrid(:),1))];
plot3(M_grid(1,:), M_grid(2,:), M_grid(3,:), '.')

for i = 1:n_imm
    m_grid{i}  = htx(Pgt{i},M_grid);
end

[P_est ,K_est] = calibSMZ(m_grid,M_grid(1:2,:));

err=0;
for i = 1:n_imm
    m_est = htx(P_est{i},M_grid);  % project with estimated camera
    err= err+ norm( m_grid{i} - m_est);
end
fprintf('CalibSMZ reproj error:\t\t %0.5g \n', err/n_imm );


%--------------------------------------------------------------
% (Auto)Calibrazione da H_infinito LVH

H12= K*eul(rand(1,3))*inv(K);
H13= K*eul(rand(1,3))*inv(K);
H23= K*eul(rand(1,3))*inv(K);

K_out  = calibLVH( {H12,H13,H23 });

fprintf('H_infty calibration %% error:\t %0.5g \n',100*abs(K_out(1,1)-K(1,1))/K(1,1)) ;


disp(' ');
%-------------------------------------------------------------------------
% Triangulation

X_est=triang_lin_batch(Pgt, m);
fprintf('Triangulation batch error:\t %0.5g \n', norm(M-X_est)/n_pts  );

%-------------------------------------------------------------------------
% Projective rec

[P_proj,M_proj] = prec(m);

for i = 1:n_imm
    m_est = htx(P_proj{i},M_proj);  % project with estimated camera
    err= err+ norm( m{i} -m_est);
end
fprintf('Projective Recon reproj error:\t %0.5g \n', err/n_imm );

%---------------------------------------------------------------------
% Bundle Adjustment

% random visibility
vis = rand(n_pts,n_imm) < .9; % is logical
figure, spy(vis),title('Visibility');ylabel('points');xlabel('images')
if any(sum(vis,2)  < 3)
    error('Not enough visibility')
end

% NOISE
for i = 1:n_imm
    P_in{i} = K\Pgt{i} + .01*rand(size(Pgt{i}));
end

[P_out,M_out] = bundleadj(P_in,M+randn(size(M)),K,m,vis);

err=0;
for i = 1:n_imm
    m_est = htx(K*P_out{i},M_out);  % project with estimated camera
    err= err+ norm( m{i} -m_est);
end

fprintf('Bundle Adjustment reproj error:\t %0.5g \n', err/n_imm );

disp(' ');
%---------------------------------------------------------------------
% Relative

X = cell2mat(Ggt(:));
Y= cell2mat(cellfun(@inv,Ggt(:)','uni',0));
Z = X * Y;

% random adjacency matrix
A = rand(n_imm) < density;
A = triu(A,1) + triu(A,1)' + diag(ones(1,n_imm));

% controllo che resti conneso;
if any(A^n_imm==0)
    error('grafo non connesso, sincronizzazione impossibile')
end

if ~ParallelRigidityTest(A,3)
    warning('grafo non p.rigido, localizzazione da bearings impossiobile')
end


% make holes
Z = Z.*kron(A,ones(4));
figure, spy(A), xlabel(''); title('Adiacenza');

% estraggo info pairwise da Z
[I,J]=find(tril(A,-1));
nedges=length(I);
U = zeros(3, nedges);
F=cell(1,1);
for k=1:nedges
    i=I(k); j=J(k);
    Tij = Z(4*i-3:4*i-1,4*j) ;
    Rij = Z(4*i-3:4*i-1,   4*j-3:4*j-1);
    U(:,k) = Tij;
    F{i,j} = inv(K)'*skew(Tij)*Rij*inv(K);
end

% estraggo rotazioni da Z
Z = Z;
Z(4:4:end, :) = [];
Z(:, 4:4:end) = [];

R = rotation_synch(Z,A);

% applico rotazioni
for k=1:nedges
    i=I(k); j=J(k);
    U(:,k) = -R{i}'*U(:,k);
end

B = adj2inc(A);
C = translation_synch(U,B);

% calcola errore in SE(3)
err =0;
for i=1:n_imm
    % altrimenti erano locations
    Gi=[R{i},-R{i}*C{i}; 0 0 0 1];
    err = err + norm(Gi*Ggt{1} - Ggt{i}, 'fro') ;
end

fprintf('SE3 Synchronization error:\t %0.5g \n',err/n_imm);

%dimentica norma
for k=1:nedges
    U(:,k) = U(:,k)/norm(U(:,k));
end
C = bearing(U,B);

% [R,t,s] = opa(reshape(cell2mat(Cgt'),3,[]),reshape(cell2mat(C'),3,[]));

R = Ggt{1}(1:3,1:3)';
s = norm(Cgt{2}-Cgt{1})/norm(R*C{2});
t = Cgt{1}/s;

% calcolo errore
err =0;
for i = 1:n_imm
    err = err + norm(Cgt{i} - s*(R*C{i}+t) ,'fro' );
end

fprintf('Localization error:\t\t %0.5g \n',err/n_imm);

%--------------------------------------------------------------
%% Sincronizzazione omografie

Hgt=cell(1,n_imm);
for i=1:n_imm
    Hgt{i} = randn(3);
    Hgt{i} = Hgt{i}./nthroot(det(Hgt{i}),3);
end

X = cell2mat(Hgt(:));
Y= cell2mat(cellfun(@inv,Hgt(:)','uni',0));
Z = X * Y;

% random adjacency matrix
A = rand(n_imm) < density;
A = triu(A,1) + triu(A,1)' + diag(ones(1,n_imm));

% make holes
Z = Z.*kron(A,ones(3));
figure, spy(A), xlabel(''); title('Adiacenza omografie');

% controllo che resti conneso;
if any(A^n_imm==0)
    error('grafo non connesso, sincronizzazione impossibile')
end

H = homog_synch(Z,A);

err =0;
for i=1:n_imm
    err = err + norm(H{i}*Hgt{1} - Hgt{i}, 'fro') ;
end

fprintf('H Synchronization error:\t %0.5g \n',err/n_imm);

disp(' ')
%--------------------------------------------------------------
% Autocalibrazione

K0 = K + 20*randn(3,3); %
K_out = autocal(F,K0);

fprintf('Autocalibration %% error:\t %0.5g \n',100*abs(K_out(1,1)-K(1,1))/K(1,1)) ;


