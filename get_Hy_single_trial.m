function Hy = get_Hy_single_trial(pts1, pts2)
 nums = size(pts1,2);
 A = zeros(nums,5);
 for i = 1: nums
     A(i,:) = [pts2(1,i), pts2(2,i), 1, -1*pts2(1,i)*pts1(2,i), -1*pts2(2,i)*pts1(2,i)];
 end
 y = pts1(2,:)';
 A_pinv = pinv(A);
 H_params = A_pinv * y;
 
 Hy = [[1.         , 0.          , 0.         ]; 
       [H_params(1), H_params(2) , H_params(3)];
       [H_params(4), H_params(5) , 1.         ]
      ];
end