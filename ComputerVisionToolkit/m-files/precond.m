function [T,m] = precond(m)
%PRECOND Normalize the coordinates of 2D points
%     size(m)
    avg = mean(m,2);
    avg = repmat(avg,1,size(m,2));
%     size(avg)
    m = m - avg;
    scale = mean(sqrt(sum(m.^2,1)))/sqrt(2);
    m=m./scale;
    
    T = [1/scale 0 -avg(1)/scale;
        0 1/scale -avg(2)/scale;
        0       0          1];
end