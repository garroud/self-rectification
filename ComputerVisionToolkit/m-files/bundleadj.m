function [P_out,M_out] = bundleadj(P,M,K,q,vis)
    %BUNDLEADJ  Bundle adjustment
    
    % le PPM sono senza K, ovvero P = [R,t]
    n_imm = length(q);
    p=6*n_imm;
    
    for i = 1:n_imm
        foo = K\[q{i}; ones(1, size(q{i},2))];
        q{i} = foo(1:2,:);  % NIC
    end
    
    % extract orientation parameters from PPM
    g = zeros(p,1);
    for i = 1:n_imm
        g(6*i-5:6*i-3) = ieul(P{i}(1:3,1:3));
        g(6*i-2:6*i) =  P{i}(1:3,4);
    end
    
    x_out = simpleGN(@(x)fobj(x,q,logical(vis)),[g;M(:)]);
    
    P_out=cell(1,n_imm);
    g_out = x_out(1:p);
    M_out = reshape(x_out(p+1:end),3,[]);
    for i = 1:n_imm
        P_out{i} = [eul(g_out(6*i-5:6*i-3)) g_out(6*i-2:6*i)];
    end
    
end

function [res,J]  = fobj(x,q,vis)
    n_imm = length(q);
    n_pts  =  size(q{1},2);
    p=6*n_imm; % end of orientation params
    
    g = x(1:p);
    M = reshape(x(p+1:end),3,[]);
    
    res=[];
    J = zeros(n_pts*2*n_imm, 6*n_imm + 3*n_pts);
    for i = 1:n_imm
        a = g(6*i-5:6*i-3); t = g(6*i-2:6*i);
        resi = (htx([eul(a) t],M) - q{i}).*vis(:,i)';
        res = [res; resi(:)];
        for j = 1:n_pts
            if vis(j,i)
                [JA,JB] =jacobianBA(a, t, M(:,j));
                rows = (i-1)*2*n_pts+2*j-1:(i-1)*2*n_pts+2*j;
                J(rows, 6*i-5:6*i) = JA;
                J(rows, p+3*j-2:p+3*j) = JB;
            end
        end
    end
end

 %     figure, spy(Jac([g;M(:)],q,ones(n_imm, size(q{1},2)))); title('Jacobiano (primaria)'); xlabel('');
 %     figure, spy(Jac([g;M(:)],q,vis)); title('Jacobiano (secondaria)'); xlabel('');
