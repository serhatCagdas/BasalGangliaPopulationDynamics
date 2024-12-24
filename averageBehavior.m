clear all, close all,clc
date_of_data = "241023ctxTest4";

param_fname = sprintf('saveVars%s.mat',date_of_data);

num_of_trial = 10;
num_of_init_cond = 8;

set_default_params;
x0 = gen_init_cond(Wc2c,Nch,num_of_init_cond,0);
Cinph = 30; 

prep_dur = 1000; % ms
phasic_dur = 50;
prep_step = int32(prep_dur/dt); 
phasic_step = int32(phasic_dur/dt);
 
for init_ind = 1:num_of_init_cond 
    
    init_ind 
 
    init_cc = x0(:,init_ind);
	
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
	% plot(t,ramp_sig/ramp_sig1(int32(1000/dt)))
	ramp_sig = ones(Nch,1)*ramp_sig;

    init_cc_idle =  0*ones(Nch,1);
    initsig_idle = sigmoid_func(init_cc_idle, param_sig_ctx_log); 
    idle_input = -1*(Wc2c*initsig_idle - init_cc_idle).*ones(Nch,int32(dur/dt));
    
    %TANH
    % initsig = sigmoid_func(init_cc, param_sig_ctx);
    initsig = sigmoid_func(init_cc, param_sig_ctx_log); 
    sig_input = -ctx_input_scale*(Wc2c*initsig - init_cc).*ones(Nch,int32(dur/dt)); 
	sig_input = (sig_input - idle_input).*ramp_sig + idle_input;
	 
    cmean     = zeros(Nch,int32(dur/dt));
    
    for trial = 1:num_of_trial

        trial

        x       = zeros(N,int32(dur/dt));
        inpData = zeros(N,int32(dur/dt));
        
        sigma_noise = 0.2*(tau_c+Tau_n)/Tau_n;
        noise1 = wgn(Nch,int32(dur/dt),sigma_noise, 'linear');  
        sigma_noise2 = 0.2*(5+Tau_n)/Tau_n;
        noise2 = wgn(N-Nch,int32(dur/dt),sigma_noise2, 'linear');
        noise = [noise1; noise2]; 
        noise_sig = zeros(N, int32(dur/dt));
        noise_sig(:,1) = noise(:,1)/50; 
 
        inpData = set_value_by_grp(inpData,params, "c", idle_input);
        inpData = set_value_by_grp(inpData,params, "th",  tal_input);
        inpData = set_value_by_grp(inpData,params, "gpi", gpi_input);
        inpData = set_value_by_grp(inpData,params, "stn", stn_input);
        inpData = set_value_by_grp(inpData,params, "s1", str1_input);
        inpData = set_value_by_grp(inpData,params, "s2", str2_input);
        
        global_ind = 2;
        %run idle time
        dad1 = 0.5;     dad2 = 5;
        run_dur = 500; % run for idle
        run_network;
        
        x(:,1) = x(:,global_ind-1) ;
        global_ind = 2;

        inpData = set_value_by_grp(inpData,params, "c", sig_input);
 
        %run prep time
        dad1 = 0;     dad2 = 0;
        run_dur = prep_dur;
        run_network;
    
        %phasic dopamine
        dad1 = 5;     dad2 = 20;
        run_dur = phasic_dur;
        run_network;
         
        %no input phase
        dad1 = 0;     dad2 = 0;
		inpData = set_value_by_grp(inpData,params, "c", idle_input);
        run_dur = dur - phasic_dur - prep_dur;
        run_network;
  
        %TANH FOR CTX 
        x_ctx = get_value_by_grp(x, params, "c");
        % z_ctx = sigmoid_func(x_ctx,param_sig_ctx); 
        z_ctx = sigmoid_func(x_ctx,param_sig_ctx_log); 

        cmean = cmean + z_ctx/num_of_trial;

        prep_activity = sigmoid_func(x((d("c") - 1)*Nch + (1:Nch),prep_step-100), param_sig_ctx_log);
        amplified_prep_activity = sigmoid_func(x((d("c") - 1)*Nch + (1:Nch),prep_step + phasic_step - 20), param_sig_ctx_log);
        tempcorr = corrcoef(prep_activity ,amplified_prep_activity );
        corr_amplifi(init_ind,trial)  = tempcorr(1,2);
    end
 
    foldername = sprintf('data%s',date_of_data);
    mkdir(foldername)
    fname = sprintf('%s//data%d',foldername,init_ind);
    save(fname,'init_cc','cmean') 

end

warn_the_end() 