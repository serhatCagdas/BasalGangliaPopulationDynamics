clear all, close all


Nd = 5;
N = 2*Nd;
A = 10;
B=5;
% D = ((exp((A/N):(A/N):A)/3)) .* eye(N);
D = (A*exp((-1:-1:-N)/B) + 1).* eye(N);

R = rand(N) -0.5;
oR = orth(R);
V = oR./vecnorm(oR);

Q = V*D*(V');
Qinv = inv(Q);

A = 3*(rand(N)-0.5) ;
S = (A-A')/2;

B = Qinv*(S - eye(N)) + eye(N);

W3 = rand(Nd) + max(max(Qinv));
R1 = Qinv(1:Nd,1:Nd);
R2 = Qinv(1:Nd,Nd+1:2*Nd);
R3 = Qinv(Nd+1:2*Nd,1:Nd);
R4 = Qinv(Nd+1:2*Nd,Nd+1:2*Nd);

W2s = -2*R3 - W3;
W2 = W2s(Nd:-1:1,Nd:-1:1);

S3 = inv(R3)*W3;
S2 = -S3(Nd:-1:1,Nd:-1:1);

S1 = inv(R1)*(R1-eye(Nd));

S = [zeros(Nd) S2; S3 zeros(Nd)]

