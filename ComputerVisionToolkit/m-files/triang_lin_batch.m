function X = triang_lin_batch(P, x)
%TRIANG_LIN_BATCH  Triangulation for n points in multiple images
    
    X=[];
    for i = 1:size(x{1},2)
        % triangulationfor the i-th point
        L=[];
        % stack equations for every camera
        for j=1:length(P)
            L = [L; skew([x{j}(:,i);1])*P{j} ]  ;
        end
        [~,~,V] = svd(L);
        X = [X, V(:,end)./V(end,end)];
       
    end
    X = X(1:3, :);
    
end


