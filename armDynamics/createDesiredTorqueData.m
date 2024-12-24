clear all, close all, clc;


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
x0 = 0;
y0 = 0.2;

%aim positions
theta_reach = deg2rad(-36:36:(6*36));
d = 0.2;

%sim params
dt = 0.1;

%feedback params
Kp = 10;
Kd = 1;


% velocity values
t = dt:dt:1000;
N = length(t); % number of timesteps
tau_reach = 120;
v0 = 0.00133; %detected by detectVel.m, aim is to reach length d = 20 cm 
v = v0*(t/tau_reach).^2.*exp(-0.5*(t/tau_reach).^2);

%find position value for each step
dstep = zeros(N,1);
for n=2:N
    dstep(n)= dstep(n-1) +  v(n)*dt;
end



for i=1:length(theta_reach)
     
    theta_goal = theta_reach(i);
    x = x0+dstep*cos(theta_goal);
    y = y0+dstep*sin(theta_goal);
    r = sqrt(x.^2 + y.^2); % distance from shoulder

    %find theta for each step
    alpha = acos(( L1^2 + L2^2 - r.^2)/(2*L1*L2));
    theta2 = pi - alpha; 

    beta = pi - atan2(y,x);
    gamma = acos((r.^2 + L1^2-L2^2)./(2*L1*r));
    theta1 = pi- beta - gamma;
    
    %graph of the trajectory
    % plot(L1*cosd(theta1) + L2*cosd(theta1 + theta2), L1*sind(theta1) + L2*sind(theta1 + theta2))

    %find theta' and theta'' for each step 
    theta1_d1 = [0; theta1(2:N)-theta1(1:N-1)]/dt;   
    theta2_d1 = [0; theta2(2:N)-theta2(1:N-1)]/dt;  
    
    theta1_act = [theta1(1) ; zeros(N-1,1)];
    theta2_act = [theta2(1) ; zeros(N-1,1)];
    theta1_act_d1 = [zeros(N,1)];
    theta2_act_d1 = [zeros(N,1)]; 
    
    %find torque for each step
    m_goal = zeros(2,N);
    for n = 1:N-1
        
        M = [a1+2*a2*cos(theta2_act(n)) a3+a2*cos(theta2_act(n));
            a3+a2*cos(theta2_act(n)) a3];

        X = a2*sin(theta2_act(n))*[-theta2_act_d1(n)*(2*theta1_act_d1(n)+ theta2_act_d1(n));
                                theta1_act_d1(n)^2];

        m_goal(:,n) = Kp*([theta1(n); theta2(n)] - [theta1_act(n); theta2_act(n)])  +...
                      Kd*([theta1_d1(n); theta2_d1(n)]- [theta1_act_d1(n); theta2_act_d1(n)]);

        temp = [theta1_act_d1(n); theta2_act_d1(n)] +...
                (M\(m_goal(:,n) - X - B*[theta1_act_d1(n); theta2_act_d1(n)]))*dt;
        
        theta1_act_d1(n+1) = temp(1);
        theta2_act_d1(n+1) = temp(2); 

        theta1_act(n+1) = theta1_act(n) + theta1_act_d1(n)*dt ;
        theta2_act(n+1) = theta2_act(n) + theta2_act_d1(n)*dt;

    end

    mdata.m{i}     = m_goal;
    i
end

mdata.theta = theta_reach;

save('mdata','mdata')

