function   [H, inliers] = homog_rob(m1,m2,method)
%HOMOG_ROB  Robust homography fit
    
    if strcmp(method,'MSAC')
        inlier_threshold = 1.0;
        [~,inliers] = simpleMSAC([m1;m2],@(x)homog_lin(x(1:2,:),x(3:4,:)),...
            @(H,x)H_sampson(H,x(1:2,:),x(3:4,:)), 4, inlier_threshold);
    elseif strcmp(method,'LMS')
        [~,inliers] = simpleLMS([m1;m2],@(x)homog_lin(x(1:2,:),x(3:4,:)),...
            @(H,x)H_sampson(H,x(1:2,:),x(3:4,:)), 4);
    else
        error('Unknown method');
    end
    
    if all(inliers==0), error('no inliers found'); end
    
    % final linear fit
    H = homog_lin(m1(:,inliers), m2(:,inliers));
end

% IRLS not implemented yet