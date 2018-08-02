function  plotcam(P,h,color,I)
    %PLOTCAM plot a camera as a pyramid with apex in the eye and image mapped
    % onto its base; h is the height of the pyramid (positive is in front of
    % the eye);  if the image is omitted a wireframe is drawn
    
    
    % Author: Andrea Fusiello
    
 
    L = 1;
    
    if ~ishold
        hold on
        wasNotHeld = 1;
    else
        wasNotHeld = 0;
    end

    if nargin == 4  %  image is given
        if size(I,3) ~= 3
            %        error('Not a RBG image');
            I(:,:,2) = I;
            I(:,:,3) = I(:,:,1);
        end
        
        um = size(I,2);
        vm = size(I,1);
        
        % scala immagine per velocizzare
        % I = imresize(I,0.25);

    else
        [K,~,~] = krt(P);
        um = 2*K(1,3);
        vm = 2*K(2,3); 
    end
    
    if nargin <=2
        color = 'b';
    end
    
    if nargin == 1
        % default pyramid height (in 3D space units)
        h = 5;
    end
    
    %  normalize P
    P = P./norm(P(3,1:3));
    
    eyep=-inv(P(1:3,1:3))*P(:,4);
    
    v1 = eyep + h*inv(P(1:3,1:3))*[0 0 1]';
    v2 = eyep + h*inv(P(1:3,1:3))*[0  vm 1]';
    v3 = eyep + h*inv(P(1:3,1:3))*[um vm 1]';
    v4 = eyep + h*inv(P(1:3,1:3))*[um 0 1]';
    
    % plot pyramid edges
    a = [eyep,v1];
    plot3(a(1,:), a(2,:), a(3,:), ['-', color], 'Linewidth',L);
    a = [eyep,v2];
    plot3(a(1,:), a(2,:), a(3,:), ['-', color], 'Linewidth',L);
    a = [eyep,v3];
    plot3(a(1,:), a(2,:), a(3,:), ['-', color], 'Linewidth',L);
    a = [eyep,v4];
    plot3(a(1,:), a(2,:), a(3,:), ['-', color], 'Linewidth',L);
    
    
    
    if nargin == 4  %  image is given
        
        % define a textured surface
        X = [v1(1), v4(1); v2(1), v3(1)];
        Y = [v1(2), v4(2); v2(2), v3(2)];
        Z = [v1(3), v4(3); v2(3), v3(3)];
        
        hb = surf(X,Y,Z);
        set(hb,'CData',I,'FaceColor','texturemap')
        % set transparency
        alpha(hb, 0.7);
        
    else
        
        % plot pyramid base wireframe
        v = [v1,v2,v3,v4,v1];
        plot3(v(1,:), v(2,:), v(3,:), ['-', color], 'Linewidth',L);
        
    end
    
    axis equal
    
    if wasNotHeld
        hold off
    end