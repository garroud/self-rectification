function M = triang_poly(v, PPM)
    % triangolazione di poligoni 2D,
    % restituisce i vertici di un poliedro
    % i poligoni in ingresso sono specificati come elenco di
    % vertici in senso antiorario (interno a sx)
    
    % ogni colonna di v{i} e un verice 2D del poligono nella
    % immagione i
    % ogni colonna di M e' un vertice 3D del poliedro
    

    L2 = [];
    for i = 1:size(PPM,2)
        % make homogeneous
        v{i} = [v{i}; ones(1,size(v{i},2)) ];

        A =[];
        for j  = 1:size(v{i},2) -1
            A = [A,  cross( v{i}(:,j), v{i}(:,j+1) ) ];
        end
        A = [A,  cross(v{i}(:,j+1) , v{i}(:,1) ) ];
        L2 = [ L2; A' * PPM{i} ] ;
    end
    
    M = lcon2vert(-L2(:,1:3), L2(:,4)) ;
    M = M';
    
    % e' piu' lento di lcon2vert ma disegna la regione
    % M = plotregion(-L(:,1:3), L(:,4)) ;