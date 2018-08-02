close all

n = 50;

disp(' ');
%--------------------------------------------------------------------------
% OPA
Y =  2*(rand(3,n)-0.5);

R = eul(rand(1,3)); 
t = rand(3,1);
s = 5;

% Apply similitude
X = s*(R*Y + t) + 0.0001*randn(size(Y));

% add outlier
X(:,1) = (X(:,1) +10)*100;

W = eye(n);  W(1,1)=0;
[R,t,s] = opa(X,Y,W); % similitude bringing Y onto X
Y_out = s*(R*Y + t);

fprintf('OPA 3D align error:\t\t %0.5g \n',  norm(X*W-Y_out*W)/n );

%--------------------------------------------------------------------------
% ICP
R = rod(rand(1,3),.24); % 20 gradi su asse random
t = [0;0;0]; % to simulate cetroid alignment

% Apply rigid motion (no scale)
X = (R*Y + t) + 0.0001*randn(size(Y));

% add missing
X(:,1:7)=[]; Y(:,end-10:end)=[];

[R,t] = icp(X,Y);  % isometria che allinea Y su X
Y_out = (R*Y + t);

Y_out(:,1:7)=[]; X(:,end-10:end)=[];
fprintf('ICP 3D align error:\t\t %0.5g \n',  norm(X -Y_out) /n);

%--------------------------------------------------------------------------
% GPA

X = rand(3,n);
Y = { eul(rand(1,3))*X+rand(3,1) + 0.0001*randn(size(X)), ...
      eul(rand(1,3))*X+rand(3,1) + 0.0001*randn(size(X)), ...
      eul(rand(1,3))*X+rand(3,1) + 0.0001*randn(size(X))};

M = eye(n); M2 = M; M3 = M;  % add missing
M2(1:3,1:3)=0; M3(end-3:end,end-3:end)=0;
W = {M, M2, M3};

[G,Xc] = gpa(Y,W);

[R,t] = opa(X,Xc); % change ref system
Y_out = (R*Xc + t);

fprintf('GPA 3D align error:\t\t %0.5g \n',  norm(X -Y_out) /n);

