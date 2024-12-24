function [Wc2c] = gen_M1_net_weigth3(N)
 
    B = 12; 
    C = 0.5;
    A = 3 - C;
    
    % evoked energy values per eigenvector
    % d = (A*exp(-(0:N-1)/B) + C);  
    A = 3;
    d = sort((A/N:A/N:A)' + 0.01*rand(N,1),"ascend");
    d2 = d;
    d2(1:2:N-1) = d(1:N/2);
    d2(2:2:N) = d(N:-1:N/2+1);
    D = diag(d2);%diag(2*rand(N,1));%diag(d(randperm(N)));
    
    % generate random orthonormal matrice
    R = rand(N); 
    oR = orth(R);
    V = oR./vecnorm(oR);
    
    %the Q values
    Q = V*D*(V');
    Vinv = V';
    Dinv = diag(1./diag(D));
    Qinv = Vinv*Dinv*Vinv';
    
    %parameters of skew-symmetric matrice
    l1 = 4*(2/N:2/N:1);%sort(4*rand(N/2,1),'ascend'); %5*rand(N/2,1);%
    Ds = zeros(N);
    
    % a Jordan form matrice to generate eigenvalues
    j=1;
    for i = 1:2:N-1
        
        Ds(i,i+1) = l1(j);
        Ds(i+1,i) = -l1(j);
        j=j+1;
    
    end
    
    % generate random orthonormal matrice for skew-sym. mat.
    R = (rand(N)-0.5);
    oR = orth(R);
    Sev = oR./vecnorm(oR);
    
    % [Sev, ~] = qr(R);
    
    % Sev = Vinv;
    S = Sev*Ds*Sev';
    % S = Vinv*Ds*Vinv';
    % A = rand(N);
    % A = A./vecnorm(A);
    % S = 10*(A - A');

    %calculate connectivity matrices.
    Wc = Qinv*(S - 1*eye(N)) + 1*eye(N);
    Wc2c = Wc;% double(abs(Wc) > 1e-2).*Wc;
end