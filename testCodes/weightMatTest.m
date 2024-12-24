clear all,close all, clc;


N = 10; 
A = 3;
D = (exp((A/N):(A/N):A)/3) .* eye(N);

R = rand(N);
oR = orth(R);
V = oR./vecnorm(oR);

Q = V*D*(V');


W = eye(N)-inv(Q);


[V2,D2] = calcInitStateByEnergy(W,N);
[ve,ie]=sort(real(D2)); 
tttest = (W'-eye(N))*Q + Q*(W-eye(N));



[Vspat,Dspat] = eig(W  );
lambdas = diag(Dspat);
figure,plot(real(lambdas), imag(lambdas), '.') 
 xlim([-5 5])
 ylim([-5 5]) 
ylabel('imag. part')
xlabel('real part')

