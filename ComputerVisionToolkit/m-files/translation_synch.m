function T = translation_synch(U,B)
%TRANSLATION_SYNCH  Translation synchronization
    
    B(1,:) = []; % remove node 1
    
    F=kron(B',eye(3));
    X=F\U(:);
    X=[0;0;0;X]; % add node 1
    X=reshape(X,3,[]);
    
    T = num2cell(reshape(X,3,[]),[1,size(X,2)]);
    
end
