function [Wc2c] = gen_M1_net_weigth2(N)

      
    % A = 3;
    % detD = 0.2;
    % B = (N-1)*(N)/(2*log(detD/(A^N))); % to achive determinant as 1
    B = 12;% 12;
    C = 0.5;
    A = 7 - C;
    % D =   (C + [(A:-A/B:A/B) zeros(1,N-B)]).*eye(N);%(C + (A:-A/N:A/N)).*eye(N);%(A*exp(-(0:N-1)/B) + C).* eye(N);
    % D = (A*exp(-(0:N-1)/B) + C).* eye(N);

    d = (A*exp(-(0:N-1)/B) + C); %(A - C)*(N:-1:1)/N + C ;%
    d2 = d;
    d2(1:2:N-1) = d(1:N/2);
    d2(2:2:N) = d(N:-1:N/2+1);
    % d2 = d(randperm(N));
    D = diag(d2);

    R = rand(N);% (rand(N)-0.5);
    oR = orth(R);
    V = oR./vecnorm(oR);
    % [V, ~] = qr(R);

    
    Q = V*D*(V');
    Vinv = V';
    Dinv = diag(1./diag(D));
    Qinv = Vinv*Dinv*Vinv';
     
    l1 = 2+sort(5*rand(N/2,1),'ascend');% normrnd(0,2,N/2,1);%3*randn(N/2);%8*rand(N/2);
    % 5.^(2/N:2/N:1);%

    Ds = zeros(N);
    j=1;
    for i = 1:2:N-1
        
        Ds(i,i+1) = l1(j);
        Ds(i+1,i) = -l1(j);
        j=j+1;
    
    end

    R = (rand(N)-0.5);
    oR = orth(R);
    Sev = oR./vecnorm(oR);
    % [Sev, ~] = qr(R);
    % Sev = Vinv;
    S = Sev*Ds*Sev';
    % S = Vinv*Ds*Vinv';
    A = rand(N);
    A = A./vecnorm(A);
    S = 10*(A - A');

    
    Wc = Qinv*(S - 1*eye(N)) + 1*eye(N);
    % % 
    % daVTA = 0.4;
    % Wc2c= daVTA*Wc/(max(real(eig(Wc))));
    Wc2c = Wc;
end