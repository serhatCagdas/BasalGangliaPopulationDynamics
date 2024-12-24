clear all, close all, clc

N = 5;


E2E = 0.1*rand(N,N);
I2I = -0.1 *rand(N,N);
E2I = 1*rand(N,N);
I2E = -1*rand(N,N);

Wc = [E2E E2I; I2E I2I];
 

Msym = (Wc + Wc')/2;
Mskw = (Wc - Wc')/2; 

daVTA = 0.4;
Wc2c  = daVTA*Wc/(max(real(eig(Wc))));

[Vspat,Dspat] = eig(Mskw  );
lambdas = diag(Dspat);
figure,plot(real(lambdas), imag(lambdas), '.') 
% xlim([-20 20])
% ylim([-20 20]) 
ylabel('imag. part')
xlabel('real part')

