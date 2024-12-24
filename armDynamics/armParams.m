% 2d arm params ref: Kao 2021
L1 = 0.3;    L2 = 0.33;
M1 = 1.4;   M2 = 1.0;
D2 = 0.16;
I1 = 0.025; I2 = 0.045;

B = [0.05 0.025; 0.025 0.05]; %damping matrix
a1 = I1 + I2 + M2*L1^2;
a2 = M2*L1*D2;
a3 = I2;

%arm initial position 
theta1init = deg2rad(10);
theta2init = deg2rad(143.54);

%aim positions
theta_reach = deg2rad(-36:36:(6*36));
d = 0.2;