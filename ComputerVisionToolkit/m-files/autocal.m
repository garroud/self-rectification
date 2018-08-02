function K_out = autocal(F,K0)
    %AUTOCAL Autocalibration from fundamental matrices
    
    k0 = [K0(1,1);K0(1,3);K0(2,3)];
    
    k_out = simpleGN(@(x)fobj(x,F),k0);
    
    K_out = [k_out(1)  0   k_out(2) ;
        0   k_out(1)  k_out(3) ;
        0    0         1];
   
end

function [res,J]  = fobj(a,F)
    
    J =[]; res=[];
    for i=1:size(F,1)
        for j=1:size(F,2)
            if ~isempty(F{i,j})
                [r, D] = jacobianHF(a,F{i,j});
                res = [res; r];
                J = [J; D];
            end
        end
    end
end
