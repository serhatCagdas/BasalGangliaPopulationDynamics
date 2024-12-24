clear all, close all, clc
N = 100;
gamma = 0.2; 
daVTA = 0.4; 

M1 =   double(rand(N) < 0.2)*2*(rand(N) -0.5);
Wc =   ((1-gamma)*(M1-M1')/2 + gamma*(M1+M1')/2 ); 

Wc2c= daVTA*Wc/(max(real(eig(Wc))));    

[Vspat,Dspat] = eig(Wc2c  );
lambdas = diag(Dspat);
figure,plot(real(lambdas), imag(lambdas), '.') 
% xlim([-20 20])
% ylim([-20 20]) 
ylabel('imag. part')
xlabel('real part')

[V,D] = calcInitStateByEnergy(Wc2c,N);