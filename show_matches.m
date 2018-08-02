function  h1 = show_matches(matches, Ia, Ib, fa, fb, sel)
%SHOW_MATCHES 

% mainly based on VLfeat examples

xa = fa(1,matches(1,sel)) ;
ya = fa(2,matches(1,sel)) ;
xb = fb(1,matches(2,sel)) + size(Ia,2) ;
yb = fb(2,matches(2,sel)) ;

% show matches
figure; clf;
h1 = imagesc(cat(2, Ia, Ib)) ;
hold on ;
h = line([xa ; xb], [ya ; yb]) ;
set(h,'linewidth', 1);
vl_plotframe(fa(:,matches(1,sel)),'color','k','linewidth',3) ;
vl_plotframe(fa(:,matches(1,sel)),'color','y','linewidth',2) ;
fb(1,:) = fb(1,:) + size(Ia,2) ;
vl_plotframe(fb(:,matches(2,sel)),'color','k','linewidth',3) ;
vl_plotframe(fb(:,matches(2,sel)),'color','y','linewidth',2) ;
axis image off ;
hold off

end

