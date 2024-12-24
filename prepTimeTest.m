clear all, close all, clc;

% Determine where your m-file's folder is.
folder = fileparts(which(mfilename)); 
% Add that folder plus all subfolders to the path.
addpath(genpath(folder));
Nch = 100;
instance_folder = sprintf('ctx241118N%dph50',Nch);
fname = sprintf("netInstances//%s//netInstance1000Prep%d.mat",instance_folder,1);
load(fname);


prep_time = [50 100 150 200 250 300 400 500 700 1000];%[20:10:100 150:50:750];
% prep_time = [100 300 700 1000];% for two example figure


num_instance = 10;

prs_mtr_error = zeros(num_instance,length(prep_time));
 
phasic_dur = 50; 
  
for  instance_ind =  8:num_instance
    
    instance_ind
    fname = sprintf("netInstances//%s//netInstance1000Prep%d.mat",instance_folder,instance_ind); % 10 for special case
    load(fname);

    for prep_time_ind = 1:length(prep_time)

        prep_time_ind 
        prep_duration = prep_time(prep_time_ind);
        prep_step = int32(prep_duration/dt);
        phasic_step = int32(phasic_dur/dt);

        %%ramp_activity 
        rise_dur = prep_duration + phasic_dur;
        trise= dt:dt:rise_dur;
        tfall= dt:dt:(dur - rise_dur);
    
        Tau_rise = 400;
        Tau_fall = 2;
        ramp_sig1 = exp(trise/Tau_rise);
        ramp_sig2 = ramp_sig1(int32(rise_dur/dt))*exp(-tfall/Tau_fall);
        t=[trise tfall+rise_dur];
        ramp_sig = [ramp_sig1 ramp_sig2]/ramp_sig1(int32(rise_dur/dt));
        % plot(t,ramp_sig/ramp_sig1(int32(1000/dt)))
        ramp_sig = ones(Nch,1)*ramp_sig;
 
        for init_ind = 1:8
            
            init_ind;
        
            x       = zeros(N,int32(dur/dt)) + 0.00002;  
            sigma_noise = 0.2*(tau_c+Tau_n)/Tau_n;
            noise1 = wgn(Nch,int32(dur/dt),sigma_noise, 'linear');  
            sigma_noise2 = 0.2*(5+Tau_n)/Tau_n;
            noise2 = wgn(N-Nch,int32(dur/dt),sigma_noise2, 'linear');
            noise = [noise1; noise2];
            % noise(:,:) = 0;%NO NOISE in training
            noise_sig = zeros(N, int32(dur/dt));
            noise_sig(:,1) = noise(:,1)/50; 
        
            inpData = zeros(N,int32(dur/dt));
            c0 = x0(:,init_ind) + 0;
            init_cc = c0; 

            init_cc_idle =  0*ones(Nch,1);
            initsig_idle = sigmoid_func(init_cc_idle, param_sig_ctx_log); 
            idle_input = -1*(Wc2c*initsig_idle - init_cc_idle).*ones(Nch,int32(dur/dt));
        
            %TANH
            % initsig = tan_a_ctx*tanh(tan_b_ctx*init_cc);
            % initsig = sigmoid_func(init_cc, param_sig_ctx);
            initsig = sigmoid_func(init_cc, param_sig_ctx_log);
            sig_input = -ctx_input_scale*(Wc2c*initsig - init_cc).*ones(Nch,int32(dur/dt));
            sig_input = (sig_input - idle_input).*ramp_sig + idle_input;

            data_in_s1 = -(0.3*initsig - init_cc);
            data_in_s2 = -(0.25*initsig - init_cc);
            
            inpData = set_value_by_grp(inpData,params, "c"  , idle_input);
            inpData = set_value_by_grp(inpData,params, "th",  tal_input);
            inpData = set_value_by_grp(inpData,params, "gpi", gpi_input);
            inpData = set_value_by_grp(inpData,params, "stn", stn_input);
            inpData = set_value_by_grp(inpData,params, "s1", str1_input);
            inpData = set_value_by_grp(inpData,params, "s2", str2_input);

            global_ind = 2;
            % run for idle
            dad1 = 0;     dad2 = 0;
            run_dur = 500; % run for idle
            run_network;
            
            x(:,1) = x(:,global_ind-1) ;
            noise_sig(:,1)= noise_sig(:,global_ind-1) ;
        
            inpData = set_value_by_grp(inpData,params, "c", sig_input);
             
            global_ind = 2;
            %run prep time
            dad1 = 0;     dad2 = 0;
            run_dur = prep_duration;
            run_network;
        
            %phasic dopamine
            dad1 = dad1_val;     dad2 = dad2_val;
            run_dur = phasic_dur;
            run_network;
             
            %no input phase
            dad1 = 0;     dad2 = 0;
            inpData = set_value_by_grp(inpData,params, "c", idle_input);  
            run_dur = 2000 - phasic_dur - prep_duration;
            run_network;
         
            %SIGMOID 
            xdata{init_ind} = sigmoid_func(x,param_sig_bgt);
            % plot_activity_by_group(x,params,"c")
         
        end
        
        for init_ind = 1:8
        
            mdata.m{init_ind} =  C*get_value_by_grp(xdata{init_ind},params, "c"); 
            % figure,plot(mdata.m{init_ind}')
        end
        
        prs_mtr_error(instance_ind,prep_time_ind) = ...
            prospective_motor_error(m_desired,mdata,(prep_step+phasic_step+1),8);
    end
end

mean_error = mean(prs_mtr_error);

fname = sprintf("prepTimeResults%s",instance_folder)
save(fname,'prs_mtr_error','mean_error','prep_time')

disp("prep time analysis for net is done")

% armParams;
% t = dt:dt:dur;
% Nn = length(t); % number of timesteps 
% testTorque;

for i = 1:5
    beep
    pause(0.5)
end