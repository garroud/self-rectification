function   [F, inliers] = fund_rob(m1,m2,method)
%FUND_ROB  Robust fundamental matrix 
       
    if strcmp(method,'MSAC')
        inlier_threshold = 1.0; % reasonable values btw .5 and 2
        [~,inliers] = simpleMSAC([m1;m2],@(x)fund_lin(x(1:2,:),x(3:4,:)),...
            @(F,x)F_sampson(F,x(1:2,:),x(3:4,:)), 8, inlier_threshold);
        
    elseif strcmp(method,'LMS')
        [~,inliers] = simpleLMS([m1;m2],@(x)fund_lin(x(1:2,:),x(3:4,:)),...
            @(F,x)F_sampson(F,x(1:2,:),x(3:4,:)), 8);
        
    elseif strcmp(method,'IRLS')
        [F,inliers] = simpleIRLS([m1;m2],@(x,w)fund_lin(x(1:2,:),x(3:4,:),w),...
            @(F,x)F_sampson(F,x(1:2,:),x(3:4,:)));
    else
        error('Unknown method');
    end
    
    if all(inliers==0), error('no inliers found'); end
    
    if ~strcmp(method,'IRLS')
        % final linear fit
        F = fund_lin(m1(:,inliers), m2(:,inliers));
    end 
end

