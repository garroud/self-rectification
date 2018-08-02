function [Hy,score] = get_Hy(points1, points2, num_trials, num_samples,threshold)
%Function Get Hy
max_align_rate = 0;
align_rate_earlystop = 0.99;
best_Hy = eye(3);
total_len = size(points1, 2);

%RANSAC process
for i = 1: num_trials
    ran_samples_idx = randperm(total_len,num_samples);
    ran_samples1 = points1(:,ran_samples_idx);
    ran_samples2 = points2(:,ran_samples_idx);
    Hy_tmp = get_Hy_single_trial(ran_samples1,ran_samples2);
    align_rate = get_align_rate(Hy_tmp, points1, points2, threshold);
    if align_rate > max_align_rate
        max_align_rate = align_rate;
        best_Hy = Hy_tmp;
    end
    if align_rate > align_rate_earlystop
        break;
    end
end

Hy = best_Hy;
score =  max_align_rate;

end


