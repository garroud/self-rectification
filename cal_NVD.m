function NVD = cal_NVD(H, height, width)
%Function calculate the NVD in the paper
vertex = [[1,1,width,width];
          [1,height,1,height]
         ];
vertex_t = htx(H,vertex);
diff_v = (vertex - vertex_t) .^ 2;
NVD_error = (diff_v(1,:) + diff_v(2,:)) .^0.5;
norm = (width^2 + height^2)^0.5;
NVD = sum(NVD_error(:))/norm;
end