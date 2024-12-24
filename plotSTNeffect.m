clear all, close all, clc;

dt = 0.1;
is_save_figs = false;
num_of_ele=100;
set_default_params;
saving_path = '';
load("acitivitySTNweightscale100.mat")

x2 = get_value_by_grp(x, params, 'c');
z = sigmoid_func(x2,param_sig_bgt);
ener_z = sum((z.^2)');
[v_e, i_e] = sort(ener_z,'descend');

figure,
subplot(2,1,1); %plot_activity_by_group(x,dt,num_of_ele,params,"c",is_save_figs, saving_path)
plot(dt:dt:dur,z(i_e(1:10),:)','Color',[0    0.4470    0.7410],'LineWidth',1);
title('weight scale 1');
text(800,80,'(w_{STN-X} scale: 1.0)');
title('A');
ylim([0 90])
xlabel ("time (ms)")
ylabel("r (Hz)")

load("acitivitySTNweightscale10.mat")

x2 = get_value_by_grp(x, params, 'c');
z = sigmoid_func(x2,param_sig_bgt);
ener_z = sum((z.^2)');
[v_e, i_e] = sort(ener_z,'descend');


subplot(2,1,2); %plot_activity_by_group(x,dt,num_of_ele,params,"c",is_save_figs, saving_path)
plot(dt:dt:dur,z(i_e(1:10),:)','Color',[0    0.4470    0.7410],'LineWidth',1);

text(800,80,'(w_{STN-X} scale: 0.1)');
title('B');
ylim([0 90])
xlabel ("time (ms)")
ylabel("r (Hz)")
set(gcf, 'Position',  [100, 50, 350, 650])