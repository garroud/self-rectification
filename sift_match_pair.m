function [ml,mr,M]= sift_match_pair(I1,I2,model)
%SIFT_MATCH_PAIR extract and match SIFT features in an image pair using 
% homography (H) of fundamental (F) models for geometruc validation   
   
    oldpath = path;
%     addpath('vlfeat-0.9.21/toolbox/');
%     addpath('ComputerVisionToolkit/ComputerVisionToolkit/m-files');

    vl_setup
    
    matches_th = 25; % minimum number of matches after RANSAC
    
    [f1,d1] = vl_sift(single(rgb2gray(I1))) ;
    [f2,d2] = vl_sift(single(rgb2gray(I2))) ;
    
    % Each column of fa is a feature frame and has the format [X;Y;S;TH]
    % Each column of D is the descriptor of the corresponding frame in F
   
    % match
    [match, scores] = vl_ubcmatch(d1, d2) ;
    
    m1 = f1(1:2,match(1,:)); m2 = f2(1:2,match(2,:));
    
    switch(model)
        case 'F'
            [M, in]  = fund_rob(m1,m2,'MSAC');
            fprintf('MSAC: F-matrix Sampson RMSE: %0.5g pixel\n',...
                sqrt(sum(F_sampson(M,m1(:,in),m2(:,in)).^2 ) /(sum(in)-1)));
        case 'H'
            [M, in]  = homog_rob(m1,m2,'MSAC');
            fprintf('MSAC: H-matrix RMS Sampson RMSE:\t %0.5g pixel\n',...
                sqrt(sum(H_sampson(M,m1(:,in),m2(:,in)).^2 ) /(sum(in)-1)));
        otherwise
            error('Unknown model.')
    end
    
    fprintf('Found %d inlier matches \n', sum(in));
    if sum(in) <  5.9 + 0.22*size(match,2) ||  sum(in) < matches_th
        warning('Not enough inliers: the pair is rejected\n');
    end
    
    show_matches(match(:,in), I1, I2, f1, f2, 1:size(match(:,in),2) );
    
    ml = m1(1:2,in);   mr = m2(1:2,in);
    
    % restore path
    path(oldpath);
    
end

