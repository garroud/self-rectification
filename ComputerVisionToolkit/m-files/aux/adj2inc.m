function  B=adj2inc(A)
%ADJ2INC Incidence matrix from adjacency    
    
% B = adj2inc(A)compute the incidence matrix
%
% INPUT:
% A is the (nV x nV) adjacency matrix associated to the epipolar graph:
% A(i,j)=1 if the relative motion between view i and j is available, 
% A(i,j)=0 otherwise. A is assumed symmetric and zero diagonal, and
% therefore only the lower triangula part (without diagonal) is considered.
%
% OUTPUT:
% B is the (nV x nE) is the incidence matrix, edges orderes as found in
% find(tril(A,-1)), which is consistent with MATLAB graphs.

% Author: Federica Arrigoni and Andrea Fusiello, 2016
% Based on adj2inc by Ondrej Sluciak <ondrej.sluciak@nt.tuwien.ac.at>

nV  = size(A,1);
[vNodes1,vNodes2] = find(tril(A,-1));
nE = length(vNodes1);
vOnes = ones(nE,1);
vEdgesidx = 1:nE;

B= sparse([vNodes1; vNodes2],...
    [vEdgesidx, vEdgesidx]',...
    [vOnes; -vOnes],...
    nV,nE);


end

