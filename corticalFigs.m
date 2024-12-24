clear all, close all, clc

includeProjectPaths();

fig_foldername = 'figures';

N= 100;

[Wc2c] = gen_M1_net_weigth3(N);


[V,D] = calcInitStateByEnergy(Wc2c,N);
[ve,ie]=sort(real(D));   

E = zeros(N,1);
A = Wc2c -eye(N);
C = 2*eye(N);
    
Q = lyap(A',A,C);

for i=1:N
    
    v = V(:,ie(N-i+1));
    E(i) = v'*Q*v;
 
end

figure,subplot(2,2,1),plot(E,'r','LineWidth',1.5)
ylabel('Evoked Energy')
xlabel('Initial State')
title("A")
% set(gcf, 'Position',  [100, 100, 400, 300])
fname = sprintf('%s//EvokEnergy.png',fig_foldername); 
% saveas(gcf,fname) 

[Vspat,Dspat] = eig( Wc2c);
lambdas = diag(Dspat);
% imag(lambdas);
subplot(2,2,2),plot(real(lambdas), imag(lambdas), '.') 
xlim([-10 10])
ylim([-10 10]);
 
ylabel('Im(\lambda)')
xlabel('Re(\lambda)')
title("B")
% set(gcf, 'Position',  [100, 100, 800, 300])

fname = sprintf('%s//Eigenvalues.png',fig_foldername); 
% saveas(gcf,fname) 

dt = 0.1;
run_dur = 1000; 
K = int32(run_dur/dt);
x = zeros(N,K);
x0 = V(:,ie(N)) ;
x(:,1) = 30*x0;%x0/norm(x0);%V(:,ie(N));%(0.5*V(:,ie(N)) + 0.5*V(:,ie(N-2)));
tau  =150;
for i = 2:K
    
    z=x(:,i-1);
    %update unit values 
    x(:,i) = x(:,i-1)  + (-x(:,i-1) + Wc2c*z)*dt/tau  ; 
     
 
end

num_of_ele = 20;
% figure,
subplot(2,2,3), plot(double(1:K)*dt,x(1:num_of_ele,:)','k');
ylim([-15 15]);
xlabel("time (ms)")
ylabel("x_i (Hz)")
title("C")

x2 = zeros(N,K);
x2(:,1) = 30*V(:,ie(1));
tau  =150;
for i = 2:K
    
    z=x2(:,i-1);
    %update unit values 
    x2(:,i) = x2(:,i-1)  + (-x2(:,i-1) + Wc2c*z)*dt/tau  ; 
     
 
end
subplot(2,2,4), 
plot(double(1:K)*dt,x2(1:num_of_ele,:)','k');
ylim([-15 15]);
xlabel("time (ms)")
ylabel("x_i (Hz)")
title("D")
set(gcf, 'Position',  [100, 100, 700, 450])



