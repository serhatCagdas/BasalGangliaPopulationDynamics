clear all, close all, clc;

dt = 0.1;

N = 20000;

t1= dt:dt:1000;
t2= dt:dt:1000;

Tau_ramp = 200;
Tau_decay = 2;
ramp_sig1 = exp(t1/Tau_ramp);
ramp_sig2 = ramp_sig1(int32(1000/dt))*exp(-t2/Tau_decay);
t=[t1 t2+1000];
ramp_sig = [ramp_sig1 ramp_sig2];
plot(t,ramp_sig/ramp_sig1(int32(1000/dt)))

ramp_sig = ones(100,1)*ramp_sig;
