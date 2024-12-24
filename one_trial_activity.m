% clear all, 
close all, clc; 

set_default_params; 
x0 = gen_random_int_cond(Wc2c,Nch,1,0); 
 
prep_dur = 1000; % ms
idle_dur = 300; %
phasic_dur = 50;
prep_step = int32(prep_dur/dt); 
phasic_step = int32(phasic_dur/dt); 

for init_ind = 1:1
    
    %initialize internal dynamic variable of neural units
    x       = zeros(N,int32(dur/dt)) + 0.00002;  
    
    %Ornstein- Uhlenbeck Process
    sigma_noise = 0.2*(tau_c+Tau_n)/Tau_n;
    noise1 = wgn(Nch,int32(dur/dt),sigma_noise, 'linear');  
    sigma_noise2 = 0.2*(5+Tau_n)/Tau_n;
    noise2 = wgn(N-Nch,int32(dur/dt),sigma_noise2, 'linear');
    noise = [noise1; noise2]; 
    noise_sig = zeros(N, int32(dur/dt));
    noise_sig(:,1) = noise(:,1)/50; 

    inpData = zeros(N,int32(dur/dt));
    init_cc = 1*x0/1 + 0;
  
    % initial condition - necessary to determine preparatory activity
    initsig = sigmoid_func(init_cc, param_sig_ctx_log);  
    sig_input = -ctx_input_scale*(Wc2c*initsig - init_cc).*ones(Nch,int32(dur/dt));
    
    %%ramp_activity
    rise_dur = prep_dur + phasic_dur;
    trise= dt:dt:rise_dur;
    tfall= dt:dt:(dur - rise_dur);

    Tau_rise = 400;
    Tau_fall = 2;
    ramp_sig1 = exp(trise/Tau_rise);
    ramp_sig2 = ramp_sig1(int32(rise_dur/dt))*exp(-tfall/Tau_fall);
    t=[trise tfall+rise_dur];
    ramp_sig = [ramp_sig1 ramp_sig2]/ramp_sig1(int32(rise_dur/dt));

    ramp_sig = ones(Nch,1)*ramp_sig;
    % plot(t,sig_input(1,:)) %uncomment to plot one input signal

    %input data for other populations 0 except for thalamus
    inpData = set_value_by_grp(inpData,params, "th",  tal_input);
    inpData = set_value_by_grp(inpData,params, "gpi", gpi_input);
    inpData = set_value_by_grp(inpData,params, "stn", stn_input);
    inpData = set_value_by_grp(inpData,params, "s1", str1_input);
    inpData = set_value_by_grp(inpData,params, "s2", str2_input);
    
    % IDLE input for basal activity of cortex
    init_cc_idle =  0*ones(Nch,1);
    initsig_idle = sigmoid_func(init_cc_idle, param_sig_ctx_log); 
    idle_input = -1*(Wc2c*initsig_idle - init_cc_idle).*ones(Nch,int32(dur/dt));
    inpData = set_value_by_grp(inpData,params, "c", idle_input);


    %run idle time to drive the cortex to basal activity
    global_ind = 2;
    dad1 = 0;     dad2 = 0;
    run_dur = idle_dur; % run for idle
    run_network;
    
    %preperation activity
    global_ind = 2;
    sig_input = (sig_input-idle_input).*ramp_sig  + idle_input;
    inpData = set_value_by_grp(inpData,params, "c", sig_input);

    run_dur = prep_dur;
    run_network;

    
    %phasic dopamine activity
    dad1 = dad1_val;     dad2 = dad2_val;
    run_dur = phasic_dur;
    run_network;
    
    %transient activity phase 
    dad1 = 0;     dad2 = 0;
    run_dur = dur - phasic_dur - prep_dur;
    inpData = set_value_by_grp(inpData,params, "c", idle_input);
    run_network;
   
   % figure,
   % plot(noise_sig(301:302,:)')
   % title('noise 1 and 2')
   % x=x(:,int32(1000/dt):int32(1300/dt));
   is_save_figs = false;
   saving_path = "figures//ctx2";
   num_of_ele = Nch;

   fg =figure,
   tifig = tiledlayout(fg, 3, 3, 'padding', 'tight', 'OuterPosition',[0 0 .995 1]);

   nexttile; plot_activity_by_group(x,dt,num_of_ele,params,"c",is_save_figs, saving_path)
   nexttile; plot_activity_by_group(x,dt,num_of_ele,params,"s1",is_save_figs, saving_path)
   nexttile; plot_activity_by_group(x,dt,num_of_ele,params,"s2",is_save_figs, saving_path)
   nexttile; plot_activity_by_group(x,dt,num_of_ele,params,"stn",is_save_figs, saving_path)
   nexttile; plot_activity_by_group(x,dt,num_of_ele,params,"gpe",is_save_figs, saving_path)
   nexttile; plot_activity_by_group(x,dt,num_of_ele,params,"gpi",is_save_figs, saving_path)
   nexttile(8); plot_activity_by_group(x,dt,num_of_ele,params,"th",is_save_figs, saving_path)
   set(gcf, 'Position',  [100, 100, 750, 500])
   data_ind(:,:,init_ind)= x((d("c") - 1)*Nch + (1:Nch),:);
   init_ind
 
end

corr_before_dop = corrcoef(x((d("c") - 1)*Nch + (1:Nch),prep_step-10),x0 )
corr_after_dop  = corrcoef(x((d("c") - 1)*Nch + (1:Nch),prep_step + phasic_step - 10),x0 )

str_activity_before_dop = x((d("s1") - 1)*Nch + (1:Nch),prep_step-10)-x((d("s2") - 1)*Nch + (1:Nch),prep_step-10);
str_activity_after_dop = x((d("s1") - 1)*Nch + (1:Nch),prep_step + phasic_step - 10)-x((d("s2") - 1)*Nch + (1:Nch),prep_step + phasic_step - 10);
corr_before_dop_str  = corrcoef(str_activity_before_dop ,x0 )
corr_after_dop_str  = corrcoef(str_activity_after_dop ,x0 )

% figure, plot(x0,x((d("c") - 1)*Nch + (1:Nch),prep_step - 10),'*')
% ylabel("cortex activity")
% xlabel("Desired init. condition")

prep_activity = sigmoid_func(x((d("c") - 1)*Nch + (1:Nch),prep_step), param_sig_ctx_log);
amplified_prep_activity = sigmoid_func(x((d("c") - 1)*Nch + (1:Nch),prep_step + phasic_step), param_sig_ctx_log);
figure, plot(prep_activity,amplified_prep_activity,'*')
ylabel("r (t=1000 ms ) Hz")
xlabel("r (t=1050 ms) Hz")
corr_amplifi  = corrcoef(prep_activity ,amplified_prep_activity )