clear all, close all, clc;

v0 = 0.133;
Tau_reach = 120;

dt = 0.1;


x = 0;

t = dt:dt:1000; 
v = v0*(t/Tau_reach).^2.*exp(-0.5*(t/Tau_reach).^2);

for i = 1:length(t)
    

    x = x + v(i)*dt;
  
end

figure, plot(t,v);