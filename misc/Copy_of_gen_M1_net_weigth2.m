function [Wc2c] = gen_M1_net_weigth2(N)

      
    % A = 3;
    % detD = 0.2;
    % B = (N-1)*(N)/(2*log(detD/(A^N))); % to achive determinant as 1
    B = 25;%12;
    C = 0.1;% 1;
    A = 12 - C;
    % D =   (C + [(A:-A/B:A/B) zeros(1,N-B)]).*eye(N);%(C + (A:-A/N:A/N)).*eye(N);%(A*exp(-(0:N-1)/B) + C).* eye(N);
    D = (A*exp(-(0:N-1)/B) + C).* eye(N);

    R = (rand(N)-0.5);
    oR = orth(R);
    V = oR./vecnorm(oR);
    
    Q = V*D*(V');
    Qinv = inv(Q);
    
    detS = 5;
    A = (rand(N)-0.5) ; %3*(rand(N)-0.5) ;
    S = 2*(A-A')/2;
    % S = (detS^(1/N))*S/(det(S)^(1/N));

    
    Wc = Qinv*(S - eye(N)) + eye(N);
    % % 
    % daVTA = 0.4;
    % Wc2c= daVTA*Wc/(max(real(eig(Wc))));
    Wc2c = Wc;
end