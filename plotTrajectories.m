clear all,
close all, clc;

load('mdata300.mat');
dt=0.1;
dur = 2000;
armParams;
t = dt:dt:dur;
Nn = length(t); % number of timesteps

theta1init = 10/180*pi;
theta2init = 143.54/180*pi;

for i=1:length(theta_reach)
      
    theta1 = [theta1init; zeros(Nn-1,1)]; 
    theta2 = [theta2init; zeros(Nn-1,1)];

    theta1_d1 = zeros(Nn,1);   
    theta2_d1 = zeros(Nn,1);  

    m_goal = mdata.m{i};
    % Binv = inv(B);

    for n = 1:Nn-1 
  
        M = [a1+2*a2*cos(theta2(n)) a3+a2*cos(theta2(n));
            a3+a2*cos(theta2(n)) a3];
    
        X = a2*sin(theta2(n))*[-theta2_d1(n)*(2*theta1_d1(n)+ theta2_d1(n));
                                theta1_d1(n)^2];
    
         
        temp = [theta1_d1(n); theta2_d1(n)] + (M\(m_goal(:,n) - X - B*[theta1_d1(n); theta2_d1(n)]))*dt;
        
        theta1_d1(n+1) = temp(1);
        theta2_d1(n+1) = temp(2);
           
        theta1(n+1) = theta1(n) + theta1_d1(n)*dt ;
        theta2(n+1) = theta2(n) + theta2_d1(n)*dt;
 
    end

    x = L1*cos(theta1)+L2*cos(theta1+theta2);
    y = L1*sin(theta1)+L2*sin(theta1+theta2);
    plot(x,y,'Color',[0 0.4470 0.7410] ,LineWidth=2)%
    hold on;
    goal_theta = mdata.theta(i);  

end
% set(gca,'XColor', 'none','YColor','none')

for i= 1:8

    figure,
    plot(t,mdata.m{i}',LineWidth=1.5)
    ylim([-3.2e-4 3.2e-4])
    set(gcf,'units','points','position',[100,100,150,150])
    set(gca,'XColor', 'none','YColor','none')

end

 