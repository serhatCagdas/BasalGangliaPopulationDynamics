clear all, close all, clc

M = 50;
N = 2*M;

p = 0.1;
R = 0.5; % spectral radius
gamm = 3;

w0 = R/sqrt(p*(1-p)*(1+gamm^2)/2);
w_ex = w0/sqrt(N);
w_inh = -gamm*w0/sqrt(N);
 
E2E = w_ex*double(rand(M,M) < 0.1);
I2I = w_inh*double(rand(M,M) < 0.1);
E2I = w_ex*double(rand(M,M) < 0.1);
I2E = w_inh*double(rand(M,M) < 0.1);

Wc2c = [E2E E2I; I2E I2I];
 

[Wc2c] = gen_M1_net_weigth(N);

[Vspat,Dspat] = eig(Wc2c  );
lambdas = diag(Dspat);
figure,plot(real(lambdas), imag(lambdas), '.') 
% xlim([-20 20])
% ylim([-20 20]) 
ylabel('imag. part')
xlabel('real part')

[V,D] = calcInitStateByEnergy(Wc2c,N);

