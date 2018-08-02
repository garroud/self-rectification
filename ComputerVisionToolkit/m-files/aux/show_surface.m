function p = show_surface( M_grid, C, s, color)
%SHOW_SURFACE: extract isosurface from volume and show
    
X = single(reshape(M_grid(1,:), s(1), s(2), s(3)));
Y = single(reshape(M_grid(2,:), s(1), s(2), s(3)));
Z = single(reshape(M_grid(3,:),s(1), s(2), s(3)));
C = reshape(C, s(1), s(2), s(3));

% [F,V] = MarchingCubes(X, Y, Z, C, 0.5 );
% p = patch('Faces',F,'Vertices',V) ;
p = patch(isosurface( X, Y, Z, C, 0.5 ) );

isonormals( X, Y, Z, C, p )

set( p, 'FaceColor', color, 'EdgeColor', 'none' );

daspect([1 1 1])
view(3); 
axis tight off
camlight 
material dull
lighting gouraud

end

