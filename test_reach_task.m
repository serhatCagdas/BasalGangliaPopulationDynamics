clear all, close all, clc;

set_default_params;

x0 = gen_init_cond(Wc2c,Nch,8,0);

load mdata.mat
m_desired= mdata;

Y = zeros(8*int32(dur/dt),2); 
X = zeros(8*int32(dur/dt),Nch);

prep_dur = 1000; % ms
phasic_dur = 50;
prep_time = int32(prep_dur/dt); % FIX THIS ONE
phasic_step = int32(phasic_dur/dt); 

Cinph = 30;

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


xdata = cell(8,1);
for init_ind = 1:8
    
    init_ind

    x       = zeros(N,int32(dur/dt)) + 0.00002;   

    sigma_noise = 0.2*(tau_c+Tau_n)/Tau_n;
    noise1 = wgn(Nch,int32(dur/dt),sigma_noise, 'linear');  
    sigma_noise2 = 0.2*(5+Tau_n)/Tau_n;
    noise2 = wgn(N-Nch,int32(dur/dt),sigma_noise2, 'linear');
    noise = [noise1; noise2];
    noise(:,:) = 0;%NO NOISE in training
    noise_sig = zeros(N, int32(dur/dt));
    noise_sig(:,1) = noise(:,1)/50; 

    inpData = zeros(N,int32(dur/dt));
    c0 = x0(:,init_ind) + 0;
    init_cc = c0;

    %TANH
    % initsig = tan_a_ctx*tanh(tan_b_ctx*init_cc);
    

    init_cc_idle =  0*ones(Nch,1);
    initsig_idle = sigmoid_func(init_cc_idle, param_sig_ctx_log); 
    idle_input = -1*(Wc2c*initsig_idle - init_cc_idle).*ones(Nch,int32(dur/dt));
    
    initsig = sigmoid_func(init_cc, param_sig_ctx_log); 
    sig_input = -ctx_input_scale*(Wc2c*initsig - init_cc).*ones(Nch,int32(dur/dt));
    sig_input = (sig_input - idle_input).*ramp_sig + idle_input;

    data_in_s1 = -(0.3*initsig - init_cc);
    data_in_s2 = -(0.25*initsig - init_cc);


    inpData = set_value_by_grp(inpData,params, "c", idle_input);
    inpData = set_value_by_grp(inpData,params, "th",  tal_input);
    inpData = set_value_by_grp(inpData,params, "gpi", gpi_input);
    inpData = set_value_by_grp(inpData,params, "stn", stn_input);
    inpData = set_value_by_grp(inpData,params, "s1", str1_input);
    inpData = set_value_by_grp(inpData,params, "s2", str2_input);
    % inpData = set_value_by_grp(inpData,params, "stn", 15);
    
    global_ind = 2;
    %run idle time
    dad1 = 0.0;     dad2 = 0.0;
    run_dur = 500; % run for idle
    run_network;
    
    x(:,1) = x(:,global_ind-1) ;

    inpData = set_value_by_grp(inpData,params, "c", sig_input);
            

    global_ind = 2;
    %run prep time
    dad1 = 0;     dad2 = 0;
    run_dur = prep_dur;
    run_network;

    
    %phasic dopamine
    dad1 = dad1_val;     dad2 = dad2_val;
    run_dur = phasic_dur;
    run_network;
    
    inpData = set_value_by_grp(inpData,params, "c", idle_input);
    %no input phase
    dad1 = 0;     dad2 = 0;
    run_dur = 2000 - phasic_dur - prep_dur;
    run_network;
 
    %SIGMOID 
    xdata{init_ind} = sigmoid_func(x,param_sig_bgt);
    % plot_activity_by_group(x,params,"c")

    X((init_ind-1)*int32(dur/dt) + 1: init_ind*int32(dur/dt),:) =...
        get_value_by_grp(xdata{init_ind},params, "c")';
    Y((init_ind-1)*int32(dur/dt) + 1: init_ind*int32(dur/dt),:) = ...
        [zeros(2,prep_time+phasic_step)  mdata.m{init_ind}(:,1:(10000-phasic_step)) zeros(2,10000-prep_time)]';
     
end

lambda2=0.000001;
Woz = inv(X'*X + lambda2*eye(Nch))*(X'*Y); 
C = Woz';

close all;
for init_ind = 1:8

    mdata.m{init_ind} =  C*get_value_by_grp(xdata{init_ind},params, "c"); 
    figure,plot([zeros(10000,2) ;mdata.m{init_ind}'])
end

prs_mtr_error =   prospective_motor_error(m_desired,mdata,(prep_time+phasic_step+1),8);

mdata2 = mdata;
for i=1:length(mdata.m)
    mdata2.m{i}(:) = 0;
end

prs_mtr_energy = prospective_motor_error(m_desired,mdata2,1,8);

norm_error = prs_mtr_error/prs_mtr_energy


armParams;
t = dt:dt:dur;
Nn = length(t); % number of timesteps
testTorque;