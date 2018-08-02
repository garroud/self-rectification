close all

%---------------------------------------------------------------------
% Prepare ground truth

K = [200 0 120
    0  200 120
    0    0   1]; % internal parameters

n= 25;

% 3D scene
d = 2;
X =  [0;0;d] +  2*(rand(3, n) - .5); % 3D points
P1 = K*camera([-1;0;0],[.05; -.05; d], [0; 1; 0]);
P2 = K*camera([ 1;0;0],[-.05; .05; d], [0; 1; 0]);
figure, plot3(X(1,:), X(2,:), X(3,:), '.k');
plotcam(P1,.5); plotcam(P2,.5);


% image points
x1 = htx(P1,X);
x2 = htx(P2,X);

x1 = x1 + 0.001*rand(size(x1));
x2 = x2 + 0.001*rand(size(x2));

% some plots
figure;
subplot(1,2,1); scatter(x1(1,:), x1(2,:),[],lines(size(x1,2)),'filled');
title('Right image'), axis([0 200 0 200]),
axis square
subplot(1,2,2); scatter(x2(1,:), x2(2,:),[],lines(size(x1,2)),'filled');
title('Left image'),  axis([0 200 0 200]),
axis square

%-------------------------------------------------------------------------
% rectification
[T1,T2,Pn1,Pn2] = rectifyP(P1,P2);
xr1 = htx(T1,x1); xr2 = htx(T2,x2);

% some plots
figure;
subplot(1,2,1); scatter(xr1(1,:), xr1(2,:),[],lines(size(x1,2)),'filled');
title('Right image rectified'), axis square, grid on
subplot(1,2,2); scatter(xr2(1,:), xr2(2,:),[],lines(size(x1,2)),'filled');
title('Left image rectified'),  axis square, grid on

disp(' ');
%--------------------------------------------------------------------------
% resection

P_est = dlt(x1, X);

x_est = htx(P_est,X);  % project with estimated camera
fprintf('Resection reproj error:\t\t %0.5g \n', norm(x1-x_est)/n);

disp(' ');
%--------------------------------------------------------------------------
% Triangulation

X1 = triang_lin({P1, P2}, {x1(:,1) ,x2(:,1)});
fprintf('Triangulation 1pt ___lin error:\t %0.5g \n', norm(X(:,1)-X1) );

X1_nl = triang_nonlin(X1, {P1, P2}, {x1(:,1) ,x2(:,1)});
fprintf('Triangulation 1pt nonlin error:\t %0.5g \n', norm(X(:,1)-X1_nl) );

X_est=triang_lin_batch({P1, P2}, {x1,x2});
fprintf('Triangulation batch error:\t %0.5g \n', norm(X-X_est)/n );

disp(' ');
%-------------------------------------------------------------------------
% separate exterior orientation

[R1,t1] = exterior_lin(x1,X,K);
fprintf('Exterior ___lin SE3 error:\t %0.5g \n',norm([R1,t1] -  K\P1));

[R2,t2] = exterior_lin(x2,X,K);
fprintf('Exterior ___lin SE3 error:\t %0.5g \n', norm([R2,t2] -  K\P2));

% refine 1
[R1,t1] = exterior_nonlin(R1, t1 , x1 , X,  K);
fprintf('Exterior nonlin SE3 error:\t %0.5g \n',norm([R1,t1] -  K\P1));

% should refine 2 as well...

X_obj = triang_lin_batch({K*[R1,t1], K*[R2,t2]}, {x1, x2});
fprintf('Separate exterior triang error:\t %0.5g \n', norm(X-X_obj) /n );

figure
plot3(X(1,:), X(2,:), X(3,:), 'or'); hold on
plot3(X_obj(1,:), X_obj(2,:), X_obj(3,:),'+b');
title('Separate exterior o.')

disp(' ');
%--------------------------------------------------------------------------
% relative orientation + absolute orientation
G12 = [K\P2; 0 0 0 1]  * inv([ K\P1; 0 0 0 1]);

[R12,t12] = relative_lin(x1, x2, K, K);
fprintf('Relative ___lin SO3 error:\t %0.5g \n', norm(R12 - G12(1:3,1:3)));

[R12,t12] = relative_nonlin(R12,t12 ,x1, x2, K, K);
fprintf('Relative nonlin SO3 errror:\t %0.5g \n',  norm(R12 - G12(1:3,1:3) ));

X_model = triang_lin_batch({K*[eye(3),zeros(3,1)], K*[R12,t12]}, {x1,x2});

% align to GT - assume the first 6 points are GCP
[R,t,s] = opa(X(:,1:6),X_model(:,1:6));
X_obj = s*(R*X_model + t*ones(1,size(X,2)));
fprintf('Relative triang error:\t\t %0.5g \n',  norm(X-X_obj));

figure
plot3(X(1,:), X(2,:), X(3,:), 'or'); hold on
plot3(X_obj(1,:), X_obj(2,:), X_obj(3,:),'+b');
title('Relativo o.')

disp(' ');
%-------------------------------------------------------------------------
% Essential

E = skew(G12(1:3,4))* G12(1:3,1:3);

E_est = essential_lin(x1,x2,K,K);
fprintf('Essential Smps error:\t\t %0.5g \n', norm(F_sampson(inv(K)'*E_est*inv(K),x1,x2))/n );

disp(' ');
%-------------------------------------------------------------------------
% Fundamental

F = fund(P1,P2);

if norm(F(3,:),'fro')/norm(F(1:2,1:2),'fro') > 1e5
    warning('F is close to affine'); end

F_est = fund_lin(x1,x2);
fprintf('Fundamental Smps error:\t\t %0.5g \n', norm(F_sampson(F_est,x1,x2))/n);

F_out = fund_nonlin(F_est, x1, x2);
fprintf('Fundamental nonlin Smps error:\t %0.5g \n', norm(F_sampson(F_out,x1,x2))/n);

out=zeros(size(x1)); out(:,1) = 100;
[F_msac, in]  = fund_rob(x1+out,x2,'MSAC');
fprintf('Fundamental MSAC Smps error:\t %0.5g \n', norm(F_sampson(F_msac,x1(:,in),x2(:,in)))/sum(in));

[F_irls,in]  = fund_rob(x1+out,x2,'IRLS');
fprintf('Fundamental IRLS Smps error:\t %0.5g \n', norm(F_sampson(F_irls,x1(:,in),x2(:,in)))/sum(in));

[F_lms,in]  = fund_rob(x1+out,x2,'LMS');
fprintf('Fundamental LMS Smps error:\t %0.5g \n', norm(F_sampson(F_lms,x1(:,in),x2(:,in)))/sum(in));

disp(' ');
%-------------------------------------------------------------------------
% Homography

[Xgrid,Ygrid] = meshgrid(-.5:0.1:.5);
M_grid = [Xgrid(:)';Ygrid(:)'; 1.5*ones(1,size(Xgrid(:),1))];
figure(1), hold on, plot3(M_grid(1,:), M_grid(2,:), M_grid(3,:), '.')

x1_grid  = htx(P1,M_grid) + 0.001*rand(size(M_grid)- [1 0]);
x2_grid  = htx(P2,M_grid) + 0.001*rand(size(M_grid)- [1 0]);

n_grid = size(x1_grid,2);

H_est  = homog_lin(x1_grid,x2_grid);
fprintf('Homography ___lin Smps error:\t %0.5g \n', norm(H_sampson(H_est,x1_grid,x2_grid))/n_grid);

H_out = homog_nonlin(H_est, x1_grid, x2_grid);
fprintf('Homography nonlin Smps error:\t %0.5g \n', norm(H_sampson(H_out,x1_grid,x2_grid))/n_grid);

out=zeros(size(x1_grid)); out(:,1) = 0;
[H_msac, in]  = homog_rob(x1_grid+out,x2_grid,'MSAC');
fprintf('Homography MSAC Smps error:\t %0.5g \n', norm(H_sampson(H_msac,x1_grid(:,in),x2_grid(:,in)))/sum(in));

[H_msac, in]  = homog_rob(x1_grid+out,x2_grid,'LMS');
fprintf('Homography LMS Smps error:\t %0.5g \n', norm(H_sampson(H_msac,x1_grid(:,in),x2_grid(:,in)))/sum(in));

disp(' ');
%-------------------------------------------------------------------------
% Uncalibrated

T = rand(4,4); % projective transform
P1p = P1 * T;
P2p = P2 * T;

[P1o,P2o,T] = eucl_upgrade(P1p, P2p, K, K);
P1_est = P1p * T;
P2est = P2p * T;

% norm(P2est(:,1:3) - P2o(:,1:3))

G12_est = [K\P2est; 0 0 0 1]  * inv([ K\P1_est; 0 0 0 1]);
fprintf('Euc upgrade SO3 error:\t\t %0.5g \n', norm(G12_est(1:3,1:3) - G12(1:3,1:3)));

