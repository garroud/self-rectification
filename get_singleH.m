%Function which does the self rectification
function [singleH,score] = get_singleH(points1, points2, num_trials, num_samples, height,width,threshold)
singleH = eye(3);
%Step 1, get Hy
[Hy ,score] = get_Hy(points1, points2, num_trials, num_samples, threshold);
singleH = Hy * singleH;
%Step 2, get Hs
Hs = get_Hs(singleH,height,width);
singleH = Hs * singleH;
%Step 3, get Hk
Hk = get_Hk(points1, points2, singleH);
singleH = Hk * singleH;

end