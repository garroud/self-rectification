function  d = F_sampson(F, m1, m2)
%F_SAMPSON Sampson signed residuals for F
    
    n = size(m1,2);
    
    % convert to homogeneous, if needed
    if size(m1,1) < 3
        m1 = [m1;ones(1,n)];
        m2 = [m2;ones(1,n)];
    end
    
    % These are *signed* (not squared) distances
    Fm1t = (F*m1)';   m2tF  = m2'*F;
    d =  diag(m2tF*m1) ./ sqrt(Fm1t(:,1).^2 + Fm1t(:,2).^2 + m2tF(:,1).^2 + m2tF(:,2).^2);
    
end

