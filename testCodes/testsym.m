clear all,

close all,

clc;

N= 50;

A= rand(N); 
S = A - A';

[Vs,Ds ] = eig(S);


B= rand(N); 
Q = B + B';
[Vq,Dq ] = eig(Q);

B = 12;
C = 0.5;
A = 7 - C;
d = (A*exp(-(0:N-1)/B) + C);  
D = diag(rand(N,1)+5);

R = (rand(N)-0.5);
oR = orth(R);
V = oR./vecnorm(oR);

%the Q values
Q = V*D*(V');
% Vinv = V';
% Dinv = diag(1./diag(D));
% Qinv = Vinv*Dinv*Vinv';

[Vspat,Dspat] = eig(Q*S);
lambdas = diag(Dspat);
imag(lambdas);
figure,plot(real(lambdas), imag(lambdas), '.') 
xlim([-10 10])
% ylim([-5 5]) 
ylabel('imag. part')
xlabel('real part')
title('W matrisi Özdeğerleri')

