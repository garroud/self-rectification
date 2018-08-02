function C = imhs(I,s)
%IMHS Harris-Stephens corner strength
    
    Sob = fspecial('sobel');
    Gaus = fspecial('gaussian',s);
    
    % directional derivatives
    Iu = filter2(Sob, I, 'same');
    Iv = filter2(Sob',I, 'same');
    
    % convolve with Gaussian
    Iuv = filter2(Gaus, Iu.*Iv,'same');
    Ivv = filter2(Gaus, Iv.^2, 'same');
    Iuu = filter2(Gaus, Iu.^2, 'same');
    
    % trace and determinant
    tr = Iuu + Ivv;
    dt = Iuu.*Ivv - Iuv.^2;
    
    C = dt - 0.04 *tr.^2; % H-S version
    % C = dt./(1+tr);     % Noble version
end
    
    
