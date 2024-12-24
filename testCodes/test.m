clear all;

N = 6;

B = rand(N) -0.5;


A = B - B';

[Vspat,Dspat] = eig(A);
lambdas = diag(Dspat);
figure,plot(real(lambdas), imag(lambdas), '.') 
xlim([-10 10])
% ylim([-5 5]) 
ylabel('imag. part')
xlabel('real part')


Vinv = inv(Vspat);
Vtran = Vspat';

[Vspat_trans,Dspat_trans] = eig(A');
lambdas = diag(Dspat);
figure,plot(real(lambdas), imag(lambdas), '.') 
xlim([-10 10])
% ylim([-5 5]) 
ylabel('imag. part')
xlabel('real part')