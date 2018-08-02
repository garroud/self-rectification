function align_rate = get_align_rate(Hy, points1, points2, threshold)
%Calculate alignment ratios for RANSAC
points2_t = htx(Hy, points2);
errors = abs(points1(2,:) - points2_t(2,:));
count = ones(size(errors));
count(errors>threshold) = 0;
align_rate = sum(count(:)) / double(size(count,2));
end