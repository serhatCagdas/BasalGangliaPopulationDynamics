clear all, close all
includeProjectPaths();
N = 6;

B = 12;
C = 0.5;
A = 7 - C;
% D =(A*exp(-(0:N-1)/B) + C).* eye(N);% (C + [(A:-A/B:A/B) zeros(1,N-B)]).*eye(N);%
d = (A*exp(-(0:N-1)/B) + C);  
% d2 = d;
% d2(1:2:N-1) = d(1:N/2);
% d2(2:2:N) = d(N:-1:N/2+1);
D = diag(d);

R = (rand(N)-0.5);
oR = orth(R);
V = oR./vecnorm(oR);

%the Q values
Q = V*D*(V');
Vinv = V';
Dinv = diag(1./diag(D));
Qinv = Vinv*Dinv*Vinv';

%parameters of skew-symmetric matrice
l1 = 2+sort(5*rand(N/2,1),'descend'); 
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

[Vs,Dtemp] = eig(Ds);
% Sev=Vinv;
S = Sev*Ds*Sev';
[Vc,Ds]=eig(S);
A = rand(N);
A = A./vecnorm(A);
S = 10*(A - A');


W = Qinv*(S - eye(N)) + eye(N);
 

% [W] = gen_M1_net_weigth2(N);
[Vspat,Dspat] = eig(Qinv*S);
lambdas = diag(Dspat);
imag(lambdas);
figure,plot(real(lambdas), imag(lambdas), '.') 
xlim([-10 10])
% ylim([-5 5]) 
ylabel('imag. part')
xlabel('real part')
title('W2 matrisi Özdeğerleri')


 
[V2,D2] = calcInitStateByEnergy(W,N);
[ve,ie]=sort(real(D2)); 
% tttest = (W'-eye(N))*Q + Q*(W-eye(N));

figure,plot(sort(abs(D2),'descend'))
title('Q matrisi Özdeğerleri')
