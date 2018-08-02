function Hk = get_Hk(pts1, pts2, H)
%Function ncalculate Hk
pts2_t = htx(H,pts2);
%The implementation tried to eliminate the effect of outliers
errors = [];
for i = 1: size(pts1,2)
    if abs(pts2_t(2,i) - pts1(2,i)< 1)
        errors = [errors,(pts1(1,i)-pts2_t(1,i))];
    end
end
errors = sort(errors, 'descend');
K = 0;

%Not consider outlier on x-axis
K = errors(1);

%Consider outlier on x-axis
%for i = 1: (size(errors,2)-1)
%    if abs(errors(i)-errors(i+1)) < 5
%        K = errors(i);
%        break;
%    end
%end

Hk = [[1,0,K];
      [0,1,0];
      [0,0,1]
     ];
end