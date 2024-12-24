function [V,D] = calcInitStateByEnergy(W,N)
    
    A = W -eye(N);
    C = 2*eye(N);
    
    Q = lyap(A',A,C);
    [V,D] = eig(Q,'vector');

end