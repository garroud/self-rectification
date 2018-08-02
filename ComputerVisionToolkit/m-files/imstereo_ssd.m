function dmap = imstereo_ssd(imL,imR,drange,ws)
    %IMSTEREO_SSD Stereo block-matching with SSD

    dmin=drange(1); dmax=drange(2);
    ssd = ones([size(imL),dmax-dmin+1])*Inf;
    for d = 0:dmax-dmin
        imR_d = circshift(imR,[0, -(dmin+d)]); % shift
        imR_d(:, end-(dmin+d):end) = 0;
        sd = (imL-imR_d).^2; % squared differences
        ssd(:,:,d+1) = filter2(ones(ws),sd); % SSD
    end
    [~,dmap]=min(ssd,[],3);
    dmap=dmap+dmin-1;
end