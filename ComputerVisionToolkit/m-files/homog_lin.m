function H = homog_lin(m1,m2)
%HOMOG_LIN  Homography with DLT algorithm

    % pre-conditioning
    [T1,m1] = precond(m1); [T2,m2] = precond(m2);
    
    H = dlt(m2, m1); 
    
    % apply the inverse scaling
    H = T2\H * T1;
end













