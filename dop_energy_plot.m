close all; clc; 

dop_vals = [1 5; 40 200; 4 20]; 
signal_energy = cell(3,1);
signal_energy{1} = zeros(10,20000);
signal_energy{2} = zeros(10,20000);
signal_energy{3} = zeros(10,20000);


for dop_ind = 1:3

    for dop_trial = 1:10
        dop_trial
        save('ener_test','dop_vals','signal_energy','dop_ind','dop_trial');
        clear all; 
        load('ener_test');
        dad1_val = dop_vals(dop_ind,1);
        dad2_val = dop_vals(dop_ind,2);
        one_trial_activity;
        
        xc = get_value_by_grp(x, params, 'c');
        z = sigmoid_func(xc, param_sig_ctx_log);
        ener_dop_val = sqrt(sum(z.^2))/Nch;
        signal_energy{dop_ind}(dop_trial,:) = ener_dop_val;
        save('ener_test','dop_vals','signal_energy');
    end
end

clear all;
one_trial_activity;

load('ener_test');
line_type_string = {'--k','-k','-.k'}; 
tplot = 1050+dt:dt:2000;
figure,
subplot(2,1,2)
for i = 1:3
    
    mean_energy = mean(signal_energy{i}); 
    hold on, plot(tplot,mean_energy(10501:end),line_type_string{i},LineWidth=1.5);
      
end
 
 title('B')
 xlim([1050,2000])
 xlabel('t (ms)')
 ylabel('Energy')
 legend({'scale = 0.1','scale = 1','scale = 10'})

subplot(2,1,1)


plot(prep_activity,amplified_prep_activity,'*')
ylabel("r (t=1000 ms ) Hz")
xlabel("r (t=1050 ms) Hz")
title('A')

set(gcf, 'Position',  [100, 100, 350, 650])