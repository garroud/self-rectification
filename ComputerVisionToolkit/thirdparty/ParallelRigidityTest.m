function rigidityDec = ParallelRigidityTest(AdjMat,d)
%PARALLELRIGIDITYTEST Test whether a graph is parallel-rigid

n = size(AdjMat,1);

 if n <=2  
     rigidityDec = false;
 else

[Ind_j, Ind_i] = find(tril(AdjMat,-1));
ss_num = length(Ind_i);

%% Generate random locations and the corresponding lines
t_rand = randn(d,n); t_rand = t_rand - sum(t_rand,2)*ones(1,n);
Q_ij_Mats = zeros(d,d,ss_num);
for k = 1:ss_num
    % t_ij = normc(t_rand(:,Ind_i(k)) - t_rand(:,Ind_j(k)));
     t_ij = (t_rand(:,Ind_i(k)) - t_rand(:,Ind_j(k)));
     t_ij = t_ij./norm(t_ij);
    Q_ij_Mats(:,:,k) = eye(d) - (t_ij*t_ij');
end

%% Compute R'*R, where R is the parallel rigidity matrix 
j_Vec_Lmat = [Ind_i Ind_j]'; j_Vec_Lmat = j_Vec_Lmat(:);
i_Vec_Lmat = kron([1:ss_num]',ones(2,1));
val_Vec_Lmat = kron(ones(ss_num,1),[1;-1]);
Lmat = kron(sparse(i_Vec_Lmat,j_Vec_Lmat,val_Vec_Lmat,ss_num,n,2*ss_num),speye(d));

i_Vec_RTRmat = reshape(kron(reshape(1:d*ss_num,d,ss_num),ones(1,d)),d^2*ss_num,1);
j_Vec_RTRmat = kron([1:d*ss_num]',ones(d,1));
val_Vec_RTRmat = reshape(Q_ij_Mats,d^2*ss_num,1);
RTRmat = Lmat'*sparse(i_Vec_RTRmat,j_Vec_RTRmat,val_Vec_RTRmat,d*ss_num,d*ss_num,d^2*ss_num)*Lmat;

%% Check rigidity 
TestMat = RTRmat + kron(ones(n,n),speye(d)) + (t_rand(:)*t_rand(:)');

try
lambd = eigs(TestMat,1,'sm'); 
catch
  lambd = 0;  
  disp('Rigidity deemed false because of the EIGS bug')
end

rigidityDec = lambd >= 1e-6;
end

return

%%*************************************************************************  
%% This function tests the parallel rigidity of a graph (with adjacency 
%% matrix AdjMat) in R^d, using the randomized procedure of [1] (see 
%% Appendix A in [1]).
%%
%% [1] O. Ozyesil, A. Singer, R. Basri,    
%%     Stable Camera Motion Estimation Using Convex Programming, 
%%     arxiv preprint (arXiv:1312.5047).
%%
%% Author: Onur Ozyesil
%%*************************************************************************  
%% Input: 
%% AdjMat : n-by-n adjacency matrix of the graph
%% d      : dimension of the problem
%% 
%% Output:
%% rigidityDec : Parallel rigidity decision (1 if the graph is decided to 
%%               be parallel rigid in R^d, 0 if decided to be flexible)
%%*************************************************************************

