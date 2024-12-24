clear all, close all,clc

param_sig.type = "logistic";
param_sig.a = 100; 
param_sig.b = 0.06; 
param_sig.c = 50;%25;


in=-60:0.1:100;

out = sigmoid_func(in,param_sig);

figure,plot(in,out);

hold on;

O = double(in>0).*in;

plot(in,O);


